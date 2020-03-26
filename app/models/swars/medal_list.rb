module Swars
  class MedalList
    cattr_accessor(:threshold) { 0.7 }

    attr_accessor :user_info

    delegate :user, :ids_scope, :real_count, :params, :at_least_value, to: :user_info

    def initialize(user_info)
      @user_info = user_info
    end

    def to_a
      @medals = []

      MedalInfo.each do |e|
        if v = instance_eval(&e.func) || params[:debug]
          @medals << e.icon
        end
      end

      if params[:debug]
        @medals << { method: "tag", name: "X", type: "is-white" }
        @medals << { method: "tag", name: "X", type: "is-black" }
        @medals << { method: "tag", name: "X", type: "is-light" }
        @medals << { method: "tag", name: "X", type: "is-dark" }
        @medals << { method: "tag", name: "X", type: "is-info" }
        # @medals << { method: "tag", name: "X", type: "is-success" }
        @medals << { method: "tag", name: "X", type: "is-warning" }
        # @medals << { method: "tag", name: "X", type: "is-danger" }
        @medals << { method: "tag", name: "💩", type: "is-white" }
        @medals << { method: "raw", name: "💩" }
        @medals << { method: "icon", name: "link", type: "is-warning" }
        @medals << { method: "icon", name: "pac-man", type: "is-warning", tag_wrap: {type: "is-black"} }
        @medals << { method: "icon", name: "timer-sand-empty", type: nil, tag_wrap: { type: "is-light" } }
      end

      @medals
    end

    def ratio_of(key)
      all_hash[key].fdiv(real_count)
    end

    private

    # def toal_counts_for(*key)
    #   key.sum { |e| all_hash[key] }
    # end

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
  end
end
