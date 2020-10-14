module Swars
  class MedalList
    cattr_accessor(:threshold) { 0.7 }

    attr_accessor :user_info

    delegate :user, :ids_scope, :real_count, :params, :at_least_value, :judge_counts, :sample_max, :current_scope, :condition_add, to: :user_info

    def initialize(user_info)
      @user_info = user_info
    end

    def to_a
      list = matched_medal_infos.collect(&:medal_params)

      if params[:debug]
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
        list << { method: "icon", name: "pac-man", type: "is-warning", tag_wrap: {type: "is-black"} }
        list << { method: "icon", name: "timer-sand-empty", type: nil, tag_wrap: { type: "is-light" } }
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
        "タグ平均偏差値"                  => deviation_avg,
        "1手詰を詰まさないでじらした割合" => jirasi_ratio,
        "絶対投了しない率"                => zettai_toryo_sinai_ratio,
        "大長考または放置率"              => long_think_ratio,
        "棋神降臨疑惑対局数"              => ai_use_battle_count,
        "長考または放置率"                => short_think_ratio,
        "最大連勝連敗"                    => win_lose_streak_max_hash,
        "タグの重み"                      => all_tag_names_hash,
      }
    end

    def matched_medal_infos
      MedalInfo.find_all { |e| instance_eval(&e.if_cond) || params[:debug] }
    end

    ################################################################################ 戦法・戦術を使った回数

    # 率
    def all_tag_ratio_for(key)
      if real_count.positive?
        all_tag_names_hash[key].fdiv(real_count)
      else
        0
      end
    end

    # all_tag_names_hash["居飛車"]         # => 1
    # all_tag_names_hash["存在しない戦法"] # => 0
    def all_tag_names_hash
      @all_tag_names_hash ||= -> {
        counts = ids_scope.all_tag_counts(at_least: at_least_value)
        counts.inject(Hash.new(0)) { |a, e| a.merge(e.name => e.count) }
      }.call
    end

    def all_tag_names
      @all_tag_names ||= all_tag_names_hash.keys
    end

    def all_tag_names_join
      @all_tag_names_join ||= all_tag_names_hash.keys.join
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
      @win_and_all_tag_names_hash ||= -> {
        s = win_scope
        s = s.joins(:battle)
        s = s.where(Swars::Battle.arel_table[:final_key].eq_any(["TORYO", "CHECKMATE"]))
        counts = s.all_tag_counts(at_least: at_least_value)
        counts.inject(Hash.new(0)) { |a, e| a.merge(e.name => e.count) }
      }.call
    end

    def win_and_all_tag_names
      @win_and_all_tag_names ||= win_and_all_tag_names_hash.keys
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
    #   @lose_and_all_tag_names_hash ||= -> {
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

    def defeated_tag_counts
      @defeated_tag_counts ||= -> {
        s = user.op_memberships   # 相手が
        s = condition_add(s)
        s = s.where(judge_key: "win") # 勝った = 自分が負けた
        s = s.limit(sample_max)

        denominator = s.count
        s = Swars::Membership.where(id: s.ids) # 再スコープ化

        tags = s.all_tag_counts(at_least: at_least_value) # 全タグ
        tags.inject(Hash.new(0)) { |a, e| a.merge(e.name => e.count.fdiv(denominator)) } # 分母は負かされ数
      }.call
    end

    ################################################################################ 居玉勝ちマン

    # 居玉で勝った率
    def igyoku_win_ratio
      if real_count.positive?
        s = win_scope
        s = s.joins(:battle)
        s = s.where(Swars::Battle.arel_table[:final_key].eq_any(["TORYO", "TIMEOUT", "CHECKMATE"]))
        s = s.where(Swars::Battle.arel_table[:turn_max].gteq(turn_max_gteq))
        s = s.tagged_with("居玉", on: :note_tags)
        s.count.fdiv(real_count)
      end
    end

    ################################################################################ レアマン

    # タグの偏差値の平均
    def deviation_avg
      if all_tag_count.positive?
        total = all_tag_names.sum do |key|
          v = 50.0
          if e = Bioshogi::TacticInfo.flat_lookup(key)
            if e = e.distribution_ratio
              v = e[:deviation]
            end
          end
          v
        end
        total.fdiv(all_tag_count)
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
        s = s.where(Swars::Membership.arel_table[:think_last].gteq(t))
        s = s.joins(:battle)
        s = s.where(Swars::Battle.arel_table[:rule_key].eq(rule_info.key))
        s = s.where(Swars::Battle.arel_table[:final_key].eq("CHECKMATE"))
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
        s = s.where(Swars::Membership.arel_table[:think_last].gteq(t))
        s = s.joins(:battle)
        s = s.where(Swars::Battle.arel_table[:rule_key].eq(rule_info.key))
        s = s.where(Swars::Battle.arel_table[:final_key].eq("TIMEOUT"))
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
        s = s.where(Swars::Membership.arel_table[:think_max].gteq(t))
        s = s.joins(:battle)
        s = s.where(Swars::Battle.arel_table[:rule_key].eq(rule_info.key))
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
        s = s.where(Swars::Membership.arel_table[:think_max].between(a...b))
        s = s.joins(:battle)
        s = s.where(Swars::Battle.arel_table[:rule_key].eq(rule_info.key))
        s.count
      end
    end

    ################################################################################ 引き分け

    # 開幕千日手数
    def start_draw_ratio
      @start_draw_ratio ||= -> {
        if new_scope_count.positive?
          s = new_scope
          s = s.where(Swars::Battle.arel_table[:final_key].eq("DRAW_SENNICHI"))
          s = s.where(Swars::Battle.arel_table[:turn_max].eq(12))
          c = s.count
          c.fdiv(new_scope_count)
        end
      }.call
    end

    # 引き分け率
    def draw_ratio
      @draw_ratio ||= -> {
        if new_scope_count.positive?
          s = new_scope
          s = s.where(Swars::Battle.arel_table[:final_key].eq("DRAW_SENNICHI"))
          c = s.count
          c.fdiv(new_scope_count)
        end
      }.call
    end

    # 引き分けを含むため current_scope は使わずに作り直す
    def new_scope
      s = user.memberships
      s = s.joins(:battle)
      s = s.merge(Swars::Battle.newest_order)  # 直近のものから取得
      s = s.limit(sample_max)
    end

    def new_scope_count
      @new_scope ||= new_scope.count
    end

    ################################################################################

    # 棋神
    # turn_max >= 2 なら think_all_avg と think_end_avg は nil ではないので turn_max >= 2 の条件を必ず入れること
    def ai_use_battle_count
      @ai_use_battle_count ||= -> {
        # A
        s = win_scope                                                                           # 勝っている
        s = s.joins(:battle)
        s = s.where(Swars::Membership.arel_table[:grade_diff].gteq(0)) if false                 # 自分と同じか格上に対して
        # s = s.where(Swars::Battle.arel_table[:final_key].eq_any(["TORYO", "TIMEOUT", "CHECKMATE"])) # もともと CHECKMATE だけだったが……いらない？
        s = s.where(Swars::Battle.arel_table[:turn_max].gteq(turn_max_gteq))                    # 50手以上の対局で

        if false
          # (B or C)
          a = Swars::Membership.where(Swars::Membership.arel_table[:think_all_avg].lteq(3))       # 指し手平均3秒以下
          a = a.or(Swars::Membership.where(Swars::Membership.arel_table[:think_end_avg].lteq(2))) # または最後の5手の平均指し手が2秒以下

          # A and (B or C)
          s = s.merge(a)
        else
          s = s.where(Swars::Membership.arel_table[:two_serial_max].gteq(15))
        end

        s.count
      }.call
    end

    ################################################################################ 連勝

    def win_lose_streak_max_hash
      @win_lose_streak_max_hash ||= win_lose_streak_max_hash_for(current_scope.pluck(:judge_key))
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

    # 最低でも2以上にすること
    def turn_max_gteq
      50
    end

    # 勝率
    def win_ratio
      @win_ratio ||= -> {
        w = judge_counts["win"]
        l = judge_counts["lose"]
        d = w + l
        if d.positive?
          w.fdiv(d)
        end
      }.call
    end

    # final_key の方法で負けた率 (分母: 負け数)
    def lose_ratio_of(final_key)
      @lose_ratio_of ||= {}
      @lose_ratio_of[final_key] ||= -> {
        if lose_count.positive?
          s = lose_scope.joins(:battle).where(Swars::Battle.arel_table[:final_key].eq(final_key))
          c = s.count
          c.fdiv(lose_count)
        end
      }.call
    end

    # 居飛車率
    def ibisha_ratio
      @ibisha_ratio ||= -> {
        d = all_tag_names_hash["居飛車"] + all_tag_names_hash["振り飛車"]
        if d.positive?
          all_tag_names_hash["居飛車"].fdiv(d)
        end
      }.call
    end

    ########################################

    def win_scope
      @win_scope ||= ids_scope.where(judge_key: "win")
    end

    def win_count
      @win_count ||= win_scope.count
    end

    def lose_scope
      @lose_scope ||= ids_scope.where(judge_key: "lose")
    end

    def lose_count
      @lose_count ||= lose_scope.count
    end
  end
end
