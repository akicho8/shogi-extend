# 使用頻度の基準を抽出する

module Swars
  module User::Stat
    class FrequencyExtractor
      class << self
        # - 高段者
        # - 100件以上対局があるもの
        def high_accuracy
          s = User.all
          s = s.where(id: Swars::Membership.select(:user_id).group(:user_id).having("COUNT(*) >= ?", 100))
          s = s.joins(:grade)
          s = s.where(Grade.arel_table[:key].eq_any(["五段", "六段", "七段", "八段"]))
          s = s.order(id: :desc)
          s = s.limit(1000)
          user_keys = s.pluck(:key)
          new.call(:user_keys => user_keys)
        end
      end

      def call(options = {})
        options = {
          :user_keys         => User::Vip.auto_crawl_user_keys,
          :sample_max        => 1000,
          :battle_count_gteq => 50,
        }.merge(options)

        rows = options[:user_keys].collect { |user_key|
          if user = User[user_key]
            stat = user.stat(options)
            if stat.ids_count >= options[:battle_count_gteq]
              stat.piece_stat.ratios_hash
            end
          end
        }.compact

        tp({ "対象人数" => rows.size })

        if rows.blank?
          return
        end

        hv = column_names.collect { |column_name|
          {
            :key   => column_name,
            :ratio => rows.sum { |e| e[column_name].to_f }.fdiv(rows.size),
          }
        }.sort_by { |e| e[:ratio] }

        tp hv
        pp hv
        hv
      end

      private

      def column_names
        @column_names ||= yield_self do
          av = []
          Bioshogi::Piece.each do |e|
            av << e.any_name(false)
          end
          Bioshogi::Piece.each do |e|
            if e.promotable
              av << e.any_name(true, char_type: :single_char)
            end
          end
          av
        end
      end
    end
  end
end
