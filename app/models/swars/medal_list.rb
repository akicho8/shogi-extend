module Swars
  class MedalList
    cattr_accessor(:threshold) { 0.7 }

    attr_accessor :user_info

    delegate :user, :ids_scope, :real_count, :params, :at_least_value, :judge_counts, to: :user_info

    def initialize(user_info)
      @user_info = user_info
    end

    def to_a
      list = matched_medal_infos.collect(&:icon)

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

    def matched_medal_infos
      MedalInfo.find_all { |e| instance_eval(&e.func) || params[:debug] }
    end

    def ratio_of(key)
      all_hash[key].fdiv(real_count)
    end

    # 居玉で勝った率
    def igyoku_win_ratio
      if real_count.nonzero?
        s = ids_scope
        s = s.where(judge_key: "win")
        s = s.joins(:battle)
        s = s.where(Swars::Battle.arel_table[:final_key].eq_any(["TORYO", "TIMEOUT", "CHECKMATE"]))
        s = s.where(Swars::Battle.arel_table[:turn_max].gteq(Rails.env.production? ? 50 : 1))
        s = s.tagged_with("居玉", on: :note_tags)
        s.count.fdiv(real_count)
      end
    end

    # タグの偏差値の平均
    def deviation_avg
      if tag_count.nonzero?
        total = all_keys.sum do |key|
          v = 50.0
          if e = Bioshogi::TacticInfo.flat_lookup(key)
            if e = e.distribution_ratio
              v = e[:deviation]
            end
          end
          v
        end
        total.fdiv(tag_count)
      end
    end

    private

    # def toal_counts_for(*key)
    #   key.sum { |e| all_hash[key] }
    # end

    # 勝率
    def win_ratio
      @win_ratio ||= -> {
        w = judge_counts["win"]
        l = judge_counts["lose"]
        s = w + l
        if s.nonzero?
          w.fdiv(s)
        end
      }.call
    end

    # 負けた数のうち final_key の方法で負けた率
    def lose_ratio_of(final_key)
      @lose_ratio_of ||= {}
      @lose_ratio_of[final_key] ||= -> {
        if lose_count.nonzero?
          lose_scope.joins(:battle).where(Swars::Battle.arel_table[:final_key].eq(final_key)).count.fdiv(lose_count)
        end
      }.call
    end

    # 負け数
    def lose_count
      @lose_count ||= lose_scope.count
    end

    # 負けた memberships のみ
    def lose_scope
      @lose_scope ||= ids_scope.where(judge_key: "lose")
    end

    # 居飛車率
    def i_ratio
      @i_ratio ||= -> {
        total = all_hash["居飛車"] + all_hash["振り飛車"]
        if total.nonzero?
          all_hash["居飛車"].fdiv(total)
        end
      }.call
    end

    # all_hash["居飛車"]         # => 1
    # all_hash["存在しない戦法"] # => 0
    def all_hash
      @all_hash ||= -> {
        all_tag_counts = ids_scope.all_tag_counts(at_least: at_least_value)
        all_tag_counts.inject(Hash.new(0)) { |a, e| a.merge(e.name => e.count) }
      }.call
    end

    def all_keys
      @all_keys ||= all_hash.keys
    end

    def tag_count
      @tag_count ||= all_hash.size
    end
  end
end
