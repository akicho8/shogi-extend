module Swars
  module UserInfo
    class MedalSet
      cattr_accessor(:threshold) { 0.7 }

      attr_reader :user_info

      delegate *[
        # win, lose
        :current_scope,
        :ids_scope,
        :win_scope,
        :win_count,
        :lose_scope,
        :lose_count,
        :win_lose_count,
        :win_lose_draw_count,

        # draw
        :draw_current_scope,
        :draw_current_scope_ids,
        :draw_ids_scope,
        :draw_scope,
        :draw_count,

        # others
        :user,
        :condition_add,
        :real_count,
        :params,
        :at_least_value,
        :judge_counts,
        :sample_max,
        :all_tag_names_hash_or_zero,
        :all_tag_names_hash,
        :fraud_battle_count,
        :turn_max_gteq,
        :xmode_counts,
      ], to: :user_info

      def initialize(user_info)
        @user_info = user_info
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
          "引き分けを除く対象サンプル数"    => real_count,
          "勝ち数"                          => win_count,
          "負け数"                          => lose_count,
          "勝率"                            => win_ratio,
          "引き分け率"                      => draw_ratio,
          "切れ負け率(分母:負け数)"         => lose_ratio_of("TIMEOUT"),
          "切断率(分母:負け数)"             => lose_ratio_of("DISCONNECT"),
          "居飛車率"                        => ibisha_ratio,
          "居玉勝率"                        => igyoku_win_ratio,
          "アヒル囲い率"                    => all_tag_ratio_for("アヒル囲い"),
          "嬉野流率"                        => all_tag_ratio_for("嬉野流"),
          "棋風"                            => user_info.rarity_ratio.ratios_hash,
          "1手詰を詰まさないでじらした割合" => jirasi_ratio,
          "絶対投了しない率"                => zettai_toryo_sinai_ratio,
          "大長考または放置率"              => long_think_ratio,
          "棋神降臨疑惑対局数"              => fraud_battle_count,
          "長考または放置率"                => short_think_ratio,
          "最大連勝連敗"                    => win_lose_streak_max_hash,
          "タグの重み"                      => all_tag_names_hash,
        }
      end

      def matched_medal_infos
        # if Rails.env.development?
        #   return MedalInfo
        # end
        MedalInfo.find_all { |e| instance_eval(&e.if_cond) || params[:medal_debug] }
      end

      # ボトルネックを探すときに使う
      # tp Swars::User.find_by!(user_key: "SugarHuuko").user_info.medal_set.time_stats
      def time_stats(sort: true)
        av = MedalInfo.collect { |e|
          ms = Benchmark.ms { instance_eval(&e.if_cond) }
          [ms, e]
        }
        if sort
          av = av.sort_by { |ms, e| -ms }
        end
        av.collect do |ms, e|
          {
            "メダル名" => e.name,
            "時間"     => "%.2f" % ms,
          }
        end
      end

      ################################################################################ 戦法・戦術を使った回数

      # 率
      def all_tag_ratio_for(key)
        if real_count.positive?
          all_tag_names_hash_or_zero(key).fdiv(real_count)
        else
          0
        end
      end

      def all_tag_names
        @all_tag_names ||= all_tag_names_hash.keys
      end

      def all_tag_names_join
        @all_tag_names_join ||= all_tag_names_hash.keys.join("/")
      end

      # タグの種類数
      def all_tag_count
        @all_tag_count ||= all_tag_names_hash.size
      end

      ################################################################################ 投了または詰みで勝ったときの、戦法・戦術を使った回数

      # 率
      def win_and_all_tag_ratio_for(key)
        if real_count.positive?
          win_and_all_tag_names_hash[key].fdiv(real_count)
        else
          0
        end
      end

      # win_and_all_tag_names_hash["居飛車"]         # => 1
      # win_and_all_tag_names_hash["存在しない戦法"] # => 0
      def win_and_all_tag_names_hash
        @win_and_all_tag_names_hash ||= yield_self do
          s = win_scope

          if false
            s = s.joins(:battle)
            s = s.where(Battle.arel_table[:final_key].eq_any(["TORYO", "TIMEOUT", "CHECKMATE"]))
          else
            s = s.toryo_timeout_checkmate_only
          end

          counts = s.all_tag_counts(at_least: at_least_value)
          counts.inject(Hash.new(0)) { |a, e| a.merge(e.name => e.count) }
        end
      end

      def win_and_all_tag_names
        @win_and_all_tag_names ||= win_and_all_tag_names_hash.keys
      end

      def win_and_all_tag_names_join
        @win_and_all_tag_names_join ||= win_and_all_tag_names.join(",")
      end

      # タグの種類数
      def win_and_all_tag_count
        @win_and_all_tag_count ||= win_and_all_tag_names_hash.size
      end

      # ################################################################################ 負けたときの、戦法・戦術を使った回数
      #
      # # 率
      # def lose_and_all_tag_ratio_for(key)
      #   if real_count.positive?
      #     lose_and_all_tag_names_hash[key].fdiv(real_count)
      #   else
      #     0
      #   end
      # end
      #
      # # lose_and_all_tag_names_hash["居飛車"]         # => 1
      # # lose_and_all_tag_names_hash["存在しない戦法"] # => 0
      # def lose_and_all_tag_names_hash
      #   @lose_and_all_tag_names_hash ||= yield_self do
      #     counts = lose_scope.all_tag_counts(at_least: at_least_value)
      #     counts.inject(Hash.new(0)) { |a, e| a.merge(e.name => e.count) }
      #   }.call
      # end
      #
      # def lose_and_all_tag_names
      #   @lose_and_all_tag_names ||= lose_and_all_tag_names_hash.keys
      # end
      #
      # # タグの種類数
      # def lose_and_all_tag_count
      #   @lose_and_all_tag_count ||= lose_and_all_tag_names_hash.size
      # end

      ################################################################################ 相手に指定のタグを使われて自分が負けた

      # かなり遅いのでやめる
      def defeated_tag_counts
        @defeated_tag_counts ||= yield_self do
          s = user.op_memberships   # 相手が
          s = condition_add(s)

          if false
            s = s.where(judge_key: "win") # 相手が勝った = 自分が負けた
          else
            s = s.s_where_judge_key_eq("win") # 相手が勝った = 自分が負けた
          end

          denominator = s.count
          s = Membership.where(id: s.ids) # 再スコープ化

          tags = s.all_tag_counts(at_least: at_least_value) # 全タグ
          tags.inject(Hash.new(0)) { |a, e| a.merge(e.name => e.count.fdiv(denominator)) } # 分母は負かされ数
        end
      end

      ################################################################################ 居玉勝ちマン

      # 居玉で勝った率
      def igyoku_win_ratio
        if real_count.positive?
          s = win_scope
          s = s.joins(:battle => :final)
          s = s.where(Final.arel_table[:key].eq_any(["TORYO", "TIMEOUT", "CHECKMATE"]))
          s = s.where(Battle.arel_table[:turn_max].gteq(turn_max_gteq))
          s = s.tagged_with("居玉", on: :defense_tags)
          s.count.fdiv(real_count)
        end
      end

      ################################################################################ 1手詰じらしマン

      def jirasi_ratio
        if real_count.positive?
          c = RuleInfo.sum { |e| teasing_count_for(e) || 0 }
          c.fdiv(real_count)
        end
      end

      def teasing_count_for(rule_info)
        if t = rule_info.teasing_limit
          s = win_scope
          s = s.where(Membership.arel_table[:think_last].gteq(t))
          s = s.joins(:battle => [:rule, :final])
          s = s.where(Rule.arel_table[:key].eq(rule_info.key))
          s = s.where(Final.arel_table[:key].eq("CHECKMATE"))
          s.count
        end
      end

      ################################################################################ 絶対投了しないマン

      def zettai_toryo_sinai_ratio
        if real_count.positive?
          c = RuleInfo.sum { |e| zettai_toryo_sinai_count_for(e) || 0 }
          c.fdiv(real_count)
        end
      end

      def zettai_toryo_sinai_count_for(rule_info)
        if t = rule_info.long_leave_alone
          s = lose_scope
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
        if real_count.positive?
          c = RuleInfo.sum { |e| taisekimachi_count_for(e) || 0 }
          c.fdiv(real_count)
        end
      end

      def taisekimachi_count_for(rule_info)
        if t = rule_info.long_leave_alone2
          s = lose_scope
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
        if real_count.positive?
          c = RuleInfo.sum { |e| long_think_count_for(e) || 0 }
          c.fdiv(real_count)
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
        if real_count.positive?
          c = RuleInfo.sum { |e| short_think_count_for(e) || 0 }
          c.fdiv(real_count)
        end
      end

      def short_think_count_for(rule_info)
        a = rule_info.short_leave_alone
        b = rule_info.long_leave_alone
        if a && b
          s = lose_scope
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
          if win_lose_draw_count.positive?
            s = draw_scope
            s = s.joins(:battle)
            s = s.where(Battle.arel_table[:turn_max].eq(12))
            c = s.count
            c.fdiv(win_lose_draw_count)
          end
        end
      end

      # 引き分け率
      # 50手以上で引き分けた回数 / 対局数
      def draw_ratio
        @draw_ratio ||= yield_self do
          if win_lose_draw_count.positive?
            s = draw_scope
            s = s.joins(:battle)
            s = s.where(Battle.arel_table[:turn_max].gteq(turn_max_gteq))
            c = s.count
            c.fdiv(win_lose_draw_count)
          end
        end
      end

      # 引き分けを含むため current_scope は使わずに作り直す
      # ただし必須の条件は入れる
      # def new_scope
      #   s = user.memberships
      #   s = condition_add(s)
      # end

      # def new_scope_count
      #   @new_scope_count ||= new_scope.count
      # end

      ################################################################################

      ################################################################################ 連勝

      def win_lose_streak_max_hash
        @win_lose_streak_max_hash ||= win_lose_streak_max_hash_for(current_scope.s_pluck_judge_key)
      end

      # []                            # => {"win" => 0, "lose" => 0}
      # ["win", "lose", "win", "win"] # => {"win" => 2, "lose" => 1}
      def win_lose_streak_max_hash_for(list)
        default = {"win" => 0, "lose" => 0}
        list                                                                        # => [:w, :w, :w, :l, :w, :w]
        list = list.chunk(&:itself)                                                 # => [:w, [:w, :w, :w], [:l, [:l], [:w, [:w, :w]]]]
        list.inject(default) { |a, (k, v)| a.merge(k => v.size) { |_, *v| v.max } } # => {:w => 3, :l => 1}
      end

      private

      # 勝率
      def win_ratio
        @win_ratio ||= yield_self do
          w = judge_counts["win"]
          l = judge_counts["lose"]
          d = w + l
          if d.positive?
            w.fdiv(d)
          end
        end
      end

      # final_key の方法で負けた率 (分母: 負け数)
      # ただし最低14手は指していること
      def lose_ratio_of(final_key)
        @lose_ratio_of ||= {}
        @lose_ratio_of[final_key] ||= yield_self do
          if lose_count.positive?
            if false
              s = lose_scope.joins(:battle).where(Battle.arel_table[:final_key].eq(final_key))
            else
              s = lose_scope.joins(:battle => :final).where(Final.arel_table[:key].eq(final_key))
            end
            s = s.where(Battle.arel_table[:turn_max].gteq(14))
            c = s.count
            c.fdiv(lose_count)
          end
        end
      end

      # 居飛車率
      def ibisha_ratio
        @ibisha_ratio ||= yield_self do
          d = all_tag_names_hash_or_zero("居飛車") + all_tag_names_hash_or_zero("振り飛車")
          if d.positive?
            all_tag_names_hash_or_zero("居飛車").fdiv(d)
          end
        end
      end

      # 19手以下で投了または詰まされて負けた率 (分母: 負け数)
      def hayai_toryo
        @hayai_toryo ||= yield_self do
          if lose_count.positive?
            s = lose_scope
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
            s = win_scope
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
