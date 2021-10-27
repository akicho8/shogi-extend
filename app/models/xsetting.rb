# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 設定 (xsettings as Xsetting)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | var_key    | 変数名   | string(255) | NOT NULL    |      | A!    |
# | var_value  | 変数値   | text(65535) |             |      |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

#
# 管理画面で変更できるシステム値
#
# ・Xsetting[:foo] で参照(formatで指定した型にキャストして返す)
# ・Xsetting[:foo] = "値" で設定
# ・nil を設定すると nil が返る
# ・変更したときだけDBにINSERTする
# ・滅多に変更しないのであれば管理画面に入れなくてもよい。(rails console で変更できるので)
#
class Xsetting < ApplicationRecord
  concerning :Core do
    included do
      class_attribute :ds_namespace
      self.ds_namespace = name.underscore

      class_attribute :ds_cache_enable
      self.ds_cache_enable = false

      validates :var_key, :presence => true, :uniqueness => true

      with_options(:allow_blank => true) do |o|
        o.validates_numericality_of :var_value, only_integer: true, :if => -> { meta.var_type == :integer }
        o.validates_numericality_of :var_value,                     :if => -> { meta.var_type == :float   }
      end

      validate do
        # めちゃくちゃな設定名はDBに入れることができないようにする
        # AvailableXsetting は動的に変わるため validates_inclusion_of は使えない
        unless AvailableXsetting[var_key]
          errors.add(:var_key, :inclusion, :value => var_key)
        end
      end

      attr_accessor :by_staff   # 誰が変更したか
    end

    class_methods do
      # 値の設定
      #
      #   値が同じ場合はDBに入らない
      #   Xsetting.var_set(:t_string_var, 1)
      #
      #   値が同じでも :force => true をつけるとDBに入る
      #   Xsetting.var_set(:t_string_var, 1, :force => true)
      #
      #   値が異なるとDBに入る
      #   Xsetting.var_set(:t_string_var, 2)
      #
      def var_set(var_key, value, options = {})
        var_key = var_key.to_s
        xsetting = find_or_default(var_key)
        value = value_cast(var_key, value) # 入力値の型変換
        unless options[:force]
          if xsetting.value == value
            if xsetting.new_record?
              logger_puts var_key, "設定値がキャッシュ値と同じなのでそれを返す"
            else
              logger_puts var_key, "設定値がDBの値と同じなのでそれを返す"
            end
            return value
          end
        end
        xsetting.by_staff = options[:by_staff]
        xsetting.var_value = value
        begin
          xsetting.save!
        rescue ActiveRecord::RecordInvalid => invalid
          logger_puts var_value, "#{invalid.class} #{invalid.record.errors.full_message.inspect}"
          raise invalid
        end
        if ds_cache_enable && Rails.cache.exist?(var_key, :namespace => ds_namespace)
          Rails.cache.delete(var_key, :namespace => ds_namespace)
          logger_puts var_key, "DBに入れてキャッシュクリア"
        else
          logger_puts var_key, "DBに入れた"
        end
        xsetting.value
      end

      def []=(var_key, value)
        var_set(var_key, value, :force => false)
      end

      # 参照
      def var_get(var_key)
        var_key = var_key.to_s
        if ds_cache_enable && Rails.cache.exist?(var_key, :namespace => ds_namespace)
          logger_puts var_key, "キャッシュに見つかったのでその値を返した"
          return YAML.load(Rails.cache.read(var_key, :namespace => ds_namespace))
        end
        xsetting = find_or_default(var_key)
        value = xsetting.value
        if ds_cache_enable
          Rails.cache.write(var_key, value.to_yaml, :namespace => ds_namespace)
          if xsetting.new_record?
            logger_puts var_key, "キャッシュに見つからないので初期値をキャッシュに設定して値を戻した"
          else
            logger_puts var_key, "キャッシュに見つからないのでDBから読み出した値をキャッシュに設定して値を戻した"
          end
        else
          if xsetting.new_record?
            logger_puts var_key, "初期値を戻した"
          else
            logger_puts var_key, "DBの値を戻した"
          end
        end
        value
      end

      alias [] var_get

      # 型変換(何回実行しても同じ値になること)
      #
      #   value_cast(:boolean_var, nil)   #=> nil
      #   value_cast(:boolean_var, false) #=> false
      #   value_cast(:boolean_var, true)  #=> true
      #   value_cast(:boolean_var, "str") #=> false ※例外を出さないことに注意
      #
      def value_cast(var_key, value)
        return if value.nil?
        meta = AvailableXsetting.fetch(var_key)
        Converters.fetch(meta.var_type)[value.to_s]
      end

      Converters = {
        string:   -> s { s                                                     },
        text:     -> s { s                                                     },
        symbol:   -> s { s.to_sym                                              },
        integer:  -> s { s.to_i                                                },
        float:    -> s { s.to_f                                                },
        boolean:  -> s { !ActiveModel::Type::Boolean::FALSE_VALUES.include?(s) },
        datetime: -> s { Time.zone.parse(s) rescue nil                         },
        date:     -> s { Date.parse(s, false) rescue nil                       },
      }

      # 最終更新日を得る
      def fetch_updated_at(var_key)
        find_or_default(var_key).updated_at
      end

      private

      # 変数名からオブジェクトを取得
      def find_or_default(var_key)
        meta = AvailableXsetting.fetch(var_key)
        find_by(:var_key => meta.key) || new(:var_key => meta.key, :var_value => meta.default)
      end

      #
      # 運用時には必須の便利メソッドたち
      #
      #   既存メソッドと重複しないように気をつけること→インスタンスにする
      #
      concerning :ClassHelperMethods do
        # 指定の一つの変数を元に戻す
        def reset(var_key, options = {})
          var_set(var_key, AvailableXsetting[var_key].default, options)
        end

        # 指定の一つの変数を元に戻す(DBから消す)
        def remove_from_db(var_key)
          find_by(:var_key => var_key)&.destroy!
        end

        # 登録済みの変数を元に戻す
        def reset_all
          all.each { |e| reset(e.var_key) }
        end

        # 更新されたDBに入っている変数名一覧
        def stored_var_keys
          all.collect(&:var_key).collect(&:to_sym)
        end

        # すべてをDBに入れる
        def store_all
          AvailableXsetting.each {|e| var_set(e.key, var_get(e.key), :force => true) }
        end

        # DBに入っているが、実際にはもう使われていない、古い変数一覧
        def refreshable_var_keys
          stored_var_keys - AvailableXsetting.keys
        end

        # DBに入っているが、実際にはもう使われていない、古い変数を削除する
        def undefined_remove
          refreshable_var_keys.each do |e|
            find_by!(:var_key => e).destroy!
          end
        end

        def ds_cache_clear
          if ds_cache_enable
            logger_puts "CLEAR", "キャッシュ全クリア"
            Rails.cache.clear(:namespace => ds_namespace)
          end
        end

        def info
          {
            :total_var_count   => AvailableXsetting.count,
            :stored_var_count  => stored_var_keys.size,
            :refreshable_count => refreshable_var_keys.size,
          }
        end

        # 変数一覧をハッシュで返す
        def to_h
          AvailableXsetting.inject({}) do |a, e|
            a.merge(e.key => var_get(e.key))
          end
        end

        private

        def logger_puts(name, messsage)
          Rails.logger.info "[xsetting] #{name} #{messsage}"
        end
      end
    end

    # 値を返す
    def value
      self.class.value_cast(var_key, var_value)
    end

    def meta
      AvailableXsetting.fetch(var_key)
    end
  end

  concerning :ChangeNoticeMethods do
    included do
      before_save do
        if by_staff && changes[:var_value]
          @before_value = self.class.var_get(var_key)
        end
        true
      end

      # 変更されたときにメールする
      after_save do
        if instance_variable_defined?(:@before_value)
          original = [@before_value, value]
          diff = original.collect {|v| v.to_s.lines.to_a.collect(&:rstrip) } # 行は配列化
          if diff.first != diff.last
            AlertLog.notify(subject: mail_subject(original), body: mail_body(diff), mail_notify: true)
          end
        end
      end
    end

    private

    def mail_subject(diff)
      who = by_staff ? "#{by_staff.name}さん" : '誰か'
      "【設定】#{who}が「#{meta.name}」を変更 (#{oneline_diff(diff)})"
    end

    def mail_body(diff)
      [
        "#{var_key} - #{meta.name}",
        "",
        "▼差分",
        DiffCop.new(*diff).to_s,
      ].join("\n")
    end

    def oneline_diff(diff)
      [
        diff.first.to_s.truncate(8, :omission => "..."),
        diff.last.to_s.truncate(8, :omission => "..."),
      ].join("→").squish
    end
  end
end
