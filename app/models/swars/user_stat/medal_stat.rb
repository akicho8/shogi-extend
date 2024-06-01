# frozen-string-literal: true

module Swars
  module UserStat
    class MedalStat < Base
      attr_reader :user_stat

      delegate *[
        :ids_scope,
        :ordered_ids_scope,

        # win, lose
        # :wl_scope,
        :win_count,
        :lose_count,
        :d_count,

        # draw

        # others
        :user,
        :base_cond,
        :ids_count,
        :params,
        :at_least_value,
        :judge_counts,
        :sample_max,
        :fraud_stat,
        :xmode_stat,
        :win_tag,
        :all_tag,
        :win_ratio,
        :consecutive_wins_and_losses_stat,
      ], to: :user_stat

      # 最低でも2以上にすること
      def turn_max_gteq
        50
      end

      def to_a
        list = matched_medal_infos.collect(&:medal_params)

        if params[:medal_debug]
          list << { method: "tag", name: "X", type: "is-white" }
          list << { method: "tag", name: "X", type: "is-black" }
          list << { method: "tag", name: "X", type: "is-light" }
          list << { method: "tag", name: "X", type: "is-dark" }
          list << { method: "tag", name: "X", type: "is-info" }
          # list << { method: "tag", name: "X", type: "is-success" }
          list << { method: "tag", name: "X", type: "is-warning" }
          # list << { method: "tag", name: "X", type: "is-danger" }
          list << { method: "tag", name: "💩", type: "is-white" }
          list << { method: "raw", name: "💩" }
          list << { method: "icon", name: "link", type: "is-warning" }
          # list << { method: "tag_with_icon", name: "pac-man", type: "is-warning", tag_wrap: { type: "is-black"} }
          # list << { method: "tag_with_icon", name: "timer-sand-empty", type: nil, tag_wrap: { type: "is-light" } }
        end

        list
      end

      def to_debug_hash
        {
          "対象サンプル数"                  => ids_count,
          "勝ち数"                          => win_count,
          "負け数"                          => lose_count,
          "勝率"                            => win_ratio,
          "引き分け率"                      => draw_ratio,
          "切れ負け率(分母:負け数)"         => lose_ratio_of("TIMEOUT"),
          "切断率(分母:負け数)"             => lose_ratio_of("DISCONNECT"),
          "居飛車率"                        => all_tag.ratio(:"居飛車"),
          "振り飛車率"                      => all_tag.ratio(:"振り飛車"),
          "居玉勝率"                        => win_tag.ratio(:"居玉"),
          "アヒル囲い率"                    => all_tag.ratio(:"アヒル囲い"),
          "嬉野流率"                        => all_tag.ratio(:"嬉野流"),
          "棋風"                            => user_stat.rarity_stat.ratios_hash,
          "1手詰を詰まさないでじらした割合" => jirasi_ratio,
          "絶対投了しない率"                => zettai_toryo_sinai_ratio,
          "大長考または放置率"              => long_think_ratio,
          "棋神降臨疑惑対局数"              => fraud_stat.count,
          "長考または放置率"                => short_think_ratio,
          "最大連勝連敗"                    => consecutive_wins_and_losses_stat.to_h,
          "タグの重み"                      => all_tag.to_h,
        }
      end

      def matched_medal_infos
        # if Rails.env.development?
        #   return MedalInfo
        # end
        MedalInfo.find_all { |e| instance_eval(&e.if_cond) || params[:medal_debug] }
      end

      # ボトルネックを探すときに使う
      # tp Swars::User.find_by!(user_key: "SugarHuuko").user_stat.medal_stat.time_stats
      def time_stats(sort: true)
        av = MedalInfo.values.shuffle.collect { |e|
          if_cond = nil
          ms = Benchmark.ms { if_cond = !!instance_eval(&e.if_cond) }
          [ms, e, if_cond]
        }
        if sort
          av = av.sort_by { |ms, e, if_cond| -ms }
        end
        av.collect do |ms, e, if_cond|
          {
            "メダル名" => e.name,
            "時間"     => "%.2f" % ms,
            "結果"     => if_cond ? "○" : "",
            "絵"       => e.medal_params[:name],
          }
        end
      end

      ################################################################################ 相手に指定のタグを使われて自分が負けた

      # かなり遅いのでやめる
      def defeated_tag_counts
        @defeated_tag_counts ||= yield_self do
          s = user.op_memberships   # 相手が
          s = base_cond(s)

          if false
            s = s.where(judge_key: "win") # 相手が勝った = 自分が負けた
          else
            s = s.s_where_judge_key_eq("win") # 相手が勝った = 自分が負けた
          end

          denominator = s.count
          s = Membership.where(id: s.ids) # 再スコープ化

          tags = s.all_tag_counts # 全タグ
          tags.inject(Hash.new(0)) { |a, e| a.merge(e.name => e.count.fdiv(denominator)) } # 分母は負かされ数 FIXME: inject が遅い
        end
      end

      ################################################################################ 1手詰じらしマン

      def jirasi_ratio
        if ids_count.positive?
          c = RuleInfo.sum { |e| teasing_count_for(e) || 0 }
          c.fdiv(ids_count)
        end
      end

      def teasing_count_for(rule_info)
        if t = rule_info.teasing_limit
          s = ids_scope.win_only
          s = s.where(Membership.arel_table[:think_last].gteq(t))
          s = s.joins(:battle => [:rule, :final])
          s = s.where(Rule.arel_table[:key].eq(rule_info.key))
          s = s.where(Final.arel_table[:key].eq("CHECKMATE"))
          s.count
        end
      end

      ################################################################################ 絶対投了しないマン

      def zettai_toryo_sinai_ratio
        if ids_count.positive?
          c = RuleInfo.sum { |e| zettai_toryo_sinai_count_for(e) || 0 }
          c.fdiv(ids_count)
        end
      end

      def zettai_toryo_sinai_count_for(rule_info)
        if t = rule_info.long_leave_alone
          s = ids_scope.lose_only
          s = s.where(Membership.arel_table[:think_last].gteq(t))
          s = s.joins(:battle => [:rule, :final])
          s = s.where(Rule.arel_table[:key].eq(rule_info.key))
          s = s.where(Final.arel_table[:key].eq("TIMEOUT"))
          s = s.where(Battle.arel_table[:turn_max].gteq(14))
          s.count
        end
      end

      ################################################################################ 相手退席待ちマン

      def taisekimachi_ratio
        if ids_count.positive?
          c = RuleInfo.sum { |e| taisekimachi_count_for(e) || 0 }
          c.fdiv(ids_count)
        end
      end

      def taisekimachi_count_for(rule_info)
        if t = rule_info.long_leave_alone2
          s = ids_scope.lose_only
          s = s.where(Membership.arel_table[:think_last].not_eq(nil))
          s = s.where(Membership.arel_table[:think_max].not_eq(Membership.arel_table[:think_last]))
          s = s.where(Membership.arel_table[:think_max].gteq(t)) # 最後ではないところで長考がある
          s = s.joins(:battle => :rule)
          s = s.where(Rule.arel_table[:key].eq(rule_info.key))
          s = s.where(Battle.arel_table[:turn_max].gteq(14))
          s.count
        end
      end

      ################################################################################ 長考

      # 大長考または放置 (勝ち負け関係なし)
      def long_think_ratio
        if ids_count.positive?
          c = RuleInfo.sum { |e| long_think_count_for(e) || 0 }
          c.fdiv(ids_count)
        end
      end

      def long_think_count_for(rule_info)
        if t = rule_info.long_leave_alone
          s = ids_scope
          s = s.where(Membership.arel_table[:think_max].gteq(t))
          s = s.joins(:battle => :rule)
          s = s.where(Rule.arel_table[:key].eq(rule_info.key))
          s.count
        end
      end

      # 小考 (負けたとき)
      def short_think_ratio
        if ids_count.positive?
          c = RuleInfo.sum { |e| short_think_count_for(e) || 0 }
          c.fdiv(ids_count)
        end
      end

      def short_think_count_for(rule_info)
        a = rule_info.short_leave_alone
        b = rule_info.long_leave_alone
        if a && b
          s = ids_scope.lose_only
          s = s.where(Membership.arel_table[:think_max].between(a...b))
          s = s.joins(:battle => :rule)
          s = s.where(Rule.arel_table[:key].eq(rule_info.key))
          s.count
        end
      end

      ################################################################################ 引き分け

      # 開幕千日手数
      # 12手で引き分けにした回数 / 対局数
      def start_draw_ratio
        @start_draw_ratio ||= yield_self do
          if ids_count.positive?
            s = ids_scope.draw_only
            s = s.joins(:battle)
            s = s.where(Battle.arel_table[:turn_max].eq(12))
            c = s.count
            c.fdiv(ids_count)
          end
        end
      end

      # 引き分け率
      # 50手以上で引き分けた回数 / 対局数
      def draw_ratio
        @draw_ratio ||= yield_self do
          if ids_count.positive?
            s = ids_scope.draw_only
            s = s.joins(:battle)
            s = s.where(Battle.arel_table[:turn_max].gteq(turn_max_gteq))
            c = s.count
            c.fdiv(ids_count)
          end
        end
      end

      ################################################################################ 連勝

      private

      # final_key の方法で負けた率 (分母: 負け数)
      # ただし最低14手は指していること
      def lose_ratio_of(final_key)
        @lose_ratio_of ||= {}
        @lose_ratio_of[final_key] ||= yield_self do
          if lose_count.positive?
            if false
              s = ids_scope.lose_only.joins(:battle).where(Battle.arel_table[:final_key].eq(final_key))
            else
              s = ids_scope.lose_only.joins(:battle => :final).where(Final.arel_table[:key].eq(final_key))
            end
            s = s.where(Battle.arel_table[:turn_max].gteq(14))
            c = s.count
            c.fdiv(lose_count)
          end
        end
      end

      # 19手以下で投了または詰まされて負けた率 (分母: 負け数)
      def hayai_toryo
        @hayai_toryo ||= yield_self do
          if lose_count.positive?
            s = ids_scope.lose_only
            s = s.joins(:battle => :final)
            s = s.where(Final.arel_table[:key].eq_any(["TORYO", "CHECKMATE"]))
            s = s.where(Battle.arel_table[:turn_max].lteq(19))
            c = s.count
            c.fdiv(lose_count)
          else
            0
          end
        end
      end

      # 100手で勝った率
      def one_hundred_win_rate
        @one_hundred_win_rate ||= yield_self do
          if win_count.positive?
            s = ids_scope.win_only
            s = s.joins(:battle)
            s = s.where(Battle.arel_table[:turn_max].eq(100))
            c = s.count
            c.fdiv(win_count)
          else
            0
          end
        end
      end
    end
  end
end
