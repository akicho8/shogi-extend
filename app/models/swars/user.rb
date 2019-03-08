# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザー (swars_users as Swars::User)
#
# |-------------------+-------------------+-------------+-------------+------+-------|
# | name              | desc              | type        | opts        | refs | index |
# |-------------------+-------------------+-------------+-------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK |      |       |
# | user_key          | User key          | string(255) | NOT NULL    |      | A!    |
# | grade_id          | Grade             | integer(8)  | NOT NULL    |      | B     |
# | last_reception_at | Last reception at | datetime    |             |      |       |
# | search_logs_count | Search logs count | integer(4)  | DEFAULT(0)  |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL    |      |       |
# |-------------------+-------------------+-------------+-------------+------+-------|

module Swars
  class User < ApplicationRecord
    has_many :memberships, dependent: :destroy # 対局時の情報(複数)
    has_many :battles, through: :memberships   # 対局(複数)
    belongs_to :grade                          # すべてのモードのなかで一番よい段級位
    has_many :search_logs, dependent: :destroy # 明示的に取り込んだ日時の記録

    before_validation do
      self.user_key ||= SecureRandom.hex
      self.grade ||= Grade.last

      # Grade が下がらないようにする
      # 例えば10分メインの人が3分を1回やっただけで30級に戻らないようにする
      if changes[:grade_id]
        ov, nv = changes[:grade_id]
        if ov && nv
          if Grade.find(ov).priority < Grade.find(nv).priority
            self.grade_id = ov
          end
        end
      end
    end

    with_options presence: true do
      validates :user_key
    end

    with_options allow_blank: true do
      validates :user_key, uniqueness: true
    end

    def to_param
      user_key
    end

    concerning :SummaryMethods do
      included do
        delegate :main_summary, :main_summary2, :summary_of, to: :summary_info
      end

      def summary_info
        @summary_info ||= SummaryInfo.new(self)
      end

      class SummaryInfo
        attr_reader :user

        def initialize(user)
          @user = user
        end

        def main_summary
          stat = Hash.new(0)


          stat["取得できた直近の対局数"] = memberships.count.to_s

          JudgeInfo.each do |e|
            stat[e.name] = judge_count_of(e.key)
          end

          stat.update(__stat)

          stat.delete("切断した")

          suffix_add(stat)

          stat
        end

        def main_summary2
          stat = Hash.new(0)

          parcentage_set(stat, "切断率", __stat["切断した"], judge_count_of(:lose), yabai: __stat["切断した"].nonzero?)
          count_set(stat, "切断回数", __stat["切断した"], yabai: __stat["切断した"].nonzero?)

          parcentage_set(stat, "棋神召喚疑惑率", kishin_hsoukan_giwaku_count, judge_count_of(:win), yabai: kishin_hsoukan_giwaku_count.nonzero?)
          count_set(stat, "棋神召喚疑惑", kishin_hsoukan_giwaku_count, yabai: kishin_hsoukan_giwaku_count.nonzero?)

          parcentage_set(stat, "投了率", __stat["投了した"], judge_count_of(:lose), yabai: __stat["投了した"].zero?)

          [:ten_min, :three_min].each do |rule_key|
            rule_info = RuleInfo.fetch(rule_key)
            ships = memberships.find_all { |e| e.battle.rule_info == rule_info }
            if ships.present?
              sec = ships.collect { |e| e.sec_list.max }.compact.max
              sec_set(stat, "【#{rule_info.name}】最大長考", sec, yabai: sec && sec >= rule_info.leave_alone_limit)

              sec = ships.collect { |e| e.sec_list.last }.compact.max
              sec_set(stat, "【#{rule_info.name}】最後の着手の最長", sec, yabai: sec && sec >= rule_info.leave_alone_limit)

              count = ships.count { |e| e.judge_info.key == :lose && e.sec_list.last.to_i >= rule_info.leave_alone_limit }
              count_set(stat, "【#{rule_info.name}】最後の着手に#{sec_to_human(rule_info.leave_alone_limit)}以上かけて負けた", count, yabai: count.nonzero?)

              count = ships.count { |e| e.summary_key == "詰ました" && e.sec_list.last >= rule_info.leave_alone_limit }
              count_set(stat, "【#{rule_info.name}】1手詰を#{sec_to_human(rule_info.leave_alone_limit)}以上かけて詰ました", count, yabai: count.nonzero?)

              scope = ships.find_all { |e| e.summary_key == "詰ました" }
              sec = scope.collect { |e| e.sec_list.last }.compact.max
              sec_set(stat, "【#{rule_info.name}】1手詰勝ちのときの着手までの最長", sec, yabai: sec && sec >= rule_info.leave_alone_limit)

              scope = ships.find_all { |e| e.summary_key == "切れ負け" }
              sec = scope.collect { |e| e.rest_sec }.max
              sec_set(stat, "【#{rule_info.name}】切れ負けたときの最長残り時間", sec, yabai: sec && sec >= rule_info.leave_alone_limit)

              count = ships.count { |e| e.summary_key == "切れ負け" && e.rest_sec >= rule_info.leave_alone_limit }
              count_set(stat, "【#{rule_info.name}】#{sec_to_human(rule_info.leave_alone_limit)}以上考えたまま切れ負けた", count, yabai: count.nonzero?)
            end
          end

          suffix_add(stat)
        end

        def summary_of(key)
          v = memberships.flat_map(&:"#{key}_tag_list")
          v = v.group_by(&:itself).transform_values(&:size) # TODO: ruby 2.6 の新しいメソッドで置き換えれるはず
          v = v.sort_by { |k, v| -v }
          Hash[v]
        end

        private

        def memberships
          @memberships ||= user.memberships.to_a
        end

        def __stat
          @__stat ||= Hash.new(0).tap { |h| memberships.each { |e| e.summary_store_to(h) } }
        end

        def kishin_hsoukan_giwaku_count
          @kishin_hsoukan_giwaku_count ||= memberships.count { |e| e.kishin_10min_winner_used? }
        end

        def suffix_add(stat)
          stat.transform_values do |e|
            if e.kind_of? Integer
              "#{e}回"
            else
              e
            end
          end
        end

        def judge_count_of(key)
          @judge_count_of ||= {}
          @judge_count_of[key] ||= memberships.count { |e| e.judge_info.key == key }
        end

        def count_set(stat, key, value, **options)
          if value.zero?
            # return
          end

          stat[key_wrap(key, options)] = value
        end

        def sec_set(stat, key, value, **options)
          if value.nil?
            return
          end

          stat[key_wrap(key, options)] = sec_to_human(value)
        end

        def parcentage_set(stat, key, numerator, denominator, **options)
          if denominator.zero?
            return
          end

          stat[key_wrap(key, options)] = parcentage(numerator, denominator)
        end

        def key_wrap(key, **options)
          if options[:yabai]
            # key = "*#{key}"
            # key =  + key
            key = Fa.icon_tag(:fas, :exclamation_circle, :class => "has-text-danger") + key
          end
          key
        end

        def parcentage(numerator, denominator)
          if denominator.zero?
            return
          end
          rate = (numerator * 100).fdiv(denominator).round(2)
          "#{rate} %"
        end

        def sec_to_human(v)
          if v.nil?
            return ""
          end

          min, sec = v.divmod(1.minutes)
          list = []
          if min.nonzero?
            list << "#{min}分"
          end
          if sec.nonzero?
            list << "#{sec}秒"
          end
          list.join
        end
      end
    end
  end
end
