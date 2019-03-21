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

    def swars_home_url
      Rails.application.routes.url_helpers.swars_home_url(self)
    end

    concerning :SummaryMethods do
      included do
        delegate :basic_summary, :secret_summary, :tactic_summary_for, to: :summary_info
      end

      def summary_info
        @summary_info ||= SummaryInfo.new(self)
      end

      class SummaryInfo
        attr_reader :user

        def initialize(user)
          @user = user
        end

        def secret_summary
          stat = Hash.new(0)

          if ms_a = ms_group["切断した"] || []
            c = ms_a.size
            count_set(stat, "切断回数", c, alert_p: c.nonzero?, memberships: ms_a)
            parcentage_set(stat, "切断率", c, judge_count_for(:lose), alert_p: c.nonzero?)
          end

          c = cheat_memberships.size
          count_set(stat, "棋神召喚疑惑", c, alert_p: c.nonzero?, memberships: cheat_memberships)
          parcentage_set(stat, "棋神召喚疑惑率", c, judge_count_for(:win), alert_p: c.nonzero?)

          ms_a = ms_group["投了した"] || []
          c = ms_a.size
          parcentage_set(stat, "投了率", c, judge_count_for(:lose), alert_p: c.zero?)

          # turn = memberships.collect { |e| e.battle.turn_max }.max
          # count_set(stat, "【#{rule_info.name}】最長手数", turn, alert_p: turn && turn >= 200, suffix: "手")

          RuleInfo.each do |rule_info|
            ships = memberships.find_all { |e| e.battle.rule_info == rule_info }

            if ships.present?
              if rule_info.related_time_p
                ms = ships.max { |e| e.sec_list.max.to_i }
                sec = ms.sec_list.max.to_i
                sec_set(stat, "【#{rule_info.name}】最大長考", sec, alert_p: sec && sec >= rule_info.leave_alone_limit, membership: ms)

                ms = ships.max { |e| e.sec_list.last.to_i }
                sec = ms.sec_list.last.to_i
                sec_set(stat, "【#{rule_info.name}】最後の着手の最長", sec, alert_p: sec && sec >= rule_info.leave_alone_limit, membership: ms)

                ms_a = ships.find_all { |e| e.judge_info.key == :lose && e.sec_list.last.to_i >= rule_info.leave_alone_limit }
                count = ms_a.count
                count_set(stat, "【#{rule_info.name}】最後の着手に#{sec_to_human(rule_info.leave_alone_limit)}以上かけて負けた", count, alert_p: count.nonzero?, memberships: ms_a)

                ms_a = ships.find_all { |e| e.summary_key == "詰ました" && e.sec_list.last >= rule_info.leave_alone_limit }
                count = ms_a.count
                count_set(stat, "【#{rule_info.name}】1手詰を#{sec_to_human(rule_info.leave_alone_limit)}以上かけて詰ました", count, alert_p: count.nonzero?, memberships: ms_a)

                scope = ships.find_all { |e| e.summary_key == "詰ました" }
                if ms = scope.max { |e| e.sec_list.last.to_i }
                  sec = ms.sec_list.last.to_i
                  sec_set(stat, "【#{rule_info.name}】1手詰勝ちのときの着手までの最長", sec, alert_p: sec && sec >= rule_info.leave_alone_limit, membership: ms)
                end

                scope = ships.find_all { |e| e.summary_key == "切れ負け" }
                if ms = scope.max { |e| e.rest_sec }
                  sec = ms.rest_sec.to_i
                  sec_set(stat, "【#{rule_info.name}】切れ負けるときの思考時間最長", sec, alert_p: sec && sec >= rule_info.leave_alone_limit, membership: ms)
                end

                ms_a = ships.find_all { |e| e.summary_key == "切れ負け" && e.rest_sec >= rule_info.leave_alone_limit }
                count = ms_a.count
                count_set(stat, "【#{rule_info.name}】#{sec_to_human(rule_info.leave_alone_limit)}以上かけて切れ負けた", count, alert_p: count.nonzero?, memberships: ms_a)
              end

              # e.summary_key == "投了した" || e.summary_key == "詰まされた" }.presence
              # if scope = ships.find_all { |e| e.judge_info.key == :lose }
              if scope = ships.find_all { |e| e.summary_key == "投了した" || e.summary_key == "詰まされた" } # { |e| e.judge_info.key == :lose } の判定だと切断負けも含まれてしまう
                if ms = scope.min { |e| e.battle.turn_max }
                  turn = ms.battle.turn_max
                  count_set(stat, "【#{rule_info.name}】(投了したor詰まされた)最短手数", turn, alert_p: turn && turn <= rule_info.most_min_turn_max_limit, suffix: "手", membership: ms)
                end
                if ms = scope.min { |e| e.total_seconds }
                  sec = ms.total_seconds
                  sec_set(stat, "【#{rule_info.name}】(投了したor詰まされた)最短時間", sec, alert_p: sec && sec <= rule_info.resignation_limit, membership: ms)
                end
              end

              if scope = ships.find_all { |e| e.judge_info.key == :win }
                if ms = scope.max { |e| e.battle.turn_max }
                  turn = ms.battle.turn_max
                  count_set(stat, "【#{rule_info.name}】(勝ち)最長手数", turn, alert_p: turn && turn >= 200, suffix: "手", membership: ms)
                end
                if rule_info.key == :ten_sec
                  if ms = scope.max { |e| e.total_seconds }
                    sec = ms.total_seconds
                    sec_set(stat, "【#{rule_info.name}】(勝ち)最長時間", sec, alert_p: sec && sec >= 10.minutes, membership: ms)
                  end
                end
              end

              if ms = ships.max { |e| e.battle.turn_max }
                turn = ms.battle.turn_max
                count_set(stat, "【#{rule_info.name}】最長手数", turn, alert_p: turn && turn >= 200, suffix: "手", membership: ms)
              end

              # scope = ships.find_all { |e| e.summary_key == "投了した" }
              # most_min_turn_max = scope.collect { |e| e.sec_total }.min
              # sec_set(stat, "【#{rule_info.name}】1手詰勝ちのときの着手までの最長", sec, alert_p: sec && sec < rule_info.resignation_limit)
            end
          end

          stat
        end

        def basic_summary
          stat = Hash.new(0)

          count_set(stat, "サンプル対局数", memberships.count, url: query_path("tag:#{user.user_key}"), suffix: "")

          parcentage_set(stat, "勝率", judge_count_for(:win), win_lose_total_count, alert_p: (0.3...0.7).exclude?(win_rate))

          JudgeInfo.each do |e|
            ms_a = judge_group_memberships(e.key)
            c = ms_a.size
            count_set(stat, e.name, c, memberships: ms_a)
          end

          ms_group.each do |summary_key, ms_a|
            c = ms_a.size
            count_set(stat, summary_key, c, memberships: ms_a)
          end

          stat.delete("切断した")

          # suffix_add(stat)

          stat
        end

        def tactic_summary_for(key)
          v = memberships.flat_map(&:"#{key}_tag_list")
          v = v.group_by(&:itself).transform_values(&:size) # TODO: ruby 2.6 の新しいメソッドで置き換えれるはず
          v = v.sort_by { |k, v| -v }
          v.inject({}) do |a, (k, v)|
            a.merge(k => h.link_to(v, query_path("muser:#{user.user_key} mtag:#{k}")))
          end
        end

        private

        def memberships
          @memberships ||= user.memberships.to_a
        end

        def ms_group
          @ms_group ||= memberships.inject({}) do |a, e|
            a[e.summary_key] ||= []
            a[e.summary_key] << e
            a
          end
        end

        def cheat_memberships
          @cheat_memberships ||= memberships.find_all { |e| e.swgod_10min_winner_used? }
        end

        # def suffix_add(stat)
        #   stat
        #   # stat.transform_values do |e|
        #   #   if e.kind_of? Integer
        #   #     "#{e}回"
        #   #   else
        #   #     e
        #   #   end
        #   # end
        # end

        def judge_count_for(key)
          judge_group_memberships(key).size
        end

        def judge_group_memberships(key)
          judge_info = JudgeInfo.fetch(key)
          @judge_group_memberships ||= {}
          @judge_group_memberships[key] ||= memberships.find_all { |e| e.judge_info == judge_info }
        end

        def win_rate
          @win_rate ||= judge_count_for(:win).fdiv(win_lose_total_count)
        end

        def win_lose_total_count
          @win_lose_total_count ||= judge_count_for(:win) + judge_count_for(:lose)
        end

        def count_set(stat, key, value, **options)
          if value.zero? && false
            return
          end

          options[:suffix] ||= "回"
          value = [value, options[:suffix]].join
          value = link_set(value, options)

          stat[key_wrap(key, options)] = value
        end

        def sec_set(stat, key, value, **options)
          if value.nil?
            return
          end

          value = sec_to_human(value)
          value = link_set(value, options)

          stat[key_wrap(key, options)] = value
        end

        def link_set(value, **options)
          ids = nil
          url = nil

          case
          when v = options[:url]
            url = v
          when membership = options[:membership]
            ids = [membership.battle.id]
          when memberships = options[:memberships].presence
            ids = memberships.collect { |e| e.battle.id }
          end

          if ids
            ids = ids.join(",")
            url = query_path("ids:#{ids}")
          end

          if url
            value = h.link_to(value, url)
          end

          value
        end

        def query_path(query)
          Rails.application.routes.url_helpers.url_for([:swars, :basic, query: query, only_path: true, per: Kaminari.config.max_per_page])
        end

        def parcentage_set(stat, key, numerator, denominator, **options)
          if denominator.zero?
            return
          end

          value = parcentage(numerator, denominator)
          value = link_set(value, options)

          stat[key_wrap(key, options)] = value
        end

        def key_wrap(key, **options)
          if options[:alert_p]
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
          if v.zero?
            return "0秒"
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

        def h
          @h ||= ApplicationController.new.view_context
        end
      end
    end
  end
end
