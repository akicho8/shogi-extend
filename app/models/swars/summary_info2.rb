module Swars
  class SummaryInfo2
    attr_reader :user

    def initialize(user)
      @user = user
    end

    let :current_scope do
      s = user.memberships
      s = s.joins(:battle, :grade).includes(:battle, :grade)
      s = s.where(Swars::Battle.arel_table[:win_user_id].not_eq(nil)) # 勝敗が必ずあるもの
      s = s.order(Swars::Battle.arel_table[:battled_at].desc)         # 直近のものから取得
      s = s.limit(50)
    end

    let :current_memberships do
      s = current_scope
      s = s.order(Swars::Battle.arel_table[:battled_at].desc)         # 直近のものから取得
      current_scope.to_a
    end

    let :judge_counts do
      judge_counts_of(current_memberships)
    end

    def judge_counts_of(memberships)
      group = memberships.group_by(&:judge_key)
      ["win", "lose"].inject({}) { |a, e| a.merge(e => (group[e] || []).count) }
    end

    def rules_hash
      group = current_memberships.group_by { |e| e.battle.rule_key }
      Swars::RuleInfo.inject({}) do |a, e|
        hash = {}
        hash[:rule_name] = e.name
        if membership = (group[e.key.to_s] || []).first
          hash[:grade_name] = membership.grade.name
        else
          hash[:grade_name] = nil
        end
        a.merge(e.key => hash)
      end
    end

    def day_list
      group = current_scope.group_by { |e| e.battle.battled_at.midnight }
      group.collect do |battled_at, memberships|
        judge_counts = judge_counts_of(memberships)

        hash = {}
        hash[:battled_at] = battled_at
        hash[:judge_counts] = judge_counts
        # if memberships.present?
        #   hash[:win_rate] = judge_counts["win"].fdiv(memberships.count)
        # end

        s = current_scope.where(id: memberships.collect(&:id))

        # hash2 = [:attack_tags, :defense_tags].inject({}) do |a, tags_method|
        #   tags = s.tag_counts_on(tags_method, at_least: 1, order: "count desc")
        #   a.merge(tags_method => tags.collect { |e| e.attributes.slice("name", "count") })
        # end
        # hash.update(hash2)

        tags = [:attack_tags, :defense_tags].flat_map do |tags_method|
          s.tag_counts_on(tags_method, at_least: 1, order: "count desc")
        end
        hash[:all_tags] = tags.sort_by { |e| -e.count }.collect { |e| e.attributes.slice("name", "count") }

        hash
      end
    end

    def buki_list
      count = current_scope.count
      tags = current_scope.tag_counts_on(:attack_tags, at_least: 1, order: "count desc")
      tags.collect do |tag|
        hash = {}
        hash[:tag] = tag.attributes.slice("name", "count")
        counts_hash = current_scope.tagged_with(tag.name, on: :attack_tags).group("judge_key").count
        hash[:judge_counts] = {"win" => 0, "lose" => 0}.merge(counts_hash)
        hash[:use_ratio] = tag.count.fdiv(count)
        hash
      end
      # group = current_scope.group_by { |e| e.battle.battled_at.midnight }
      # group.collect do |battled_at, memberships|
      #   judge_counts = judge_counts_of(memberships)
      #
      #   hash = {}
      #   hash[:battled_at] = battled_at
      #   hash[:judge_counts] = judge_counts
      #   if memberships.present?
      #     hash[:win_rate] = judge_counts["win"].fdiv(memberships.count)
      #   end
      #
      #   s = current_scope.where(id: memberships.collect(&:id))
      #
      #   hash2 = [:attack_tags, :defense_tags].inject({}) do |a, tags_method|
      #     tags = s.tag_counts_on(tags_method, at_least: 1, order: "count desc")
      #     a.merge(tags_method => tags.collect { |e| e.attributes.slice("name", "count") })
      #   end
      #   hash.update(hash2)
      #
      #   tags = [:attack_tags, :defense_tags].flat_map do |tags_method|
      #     s.tag_counts_on(tags_method, at_least: 1, order: "count desc")
      #   end
      #   hash[:all_tags] = tags.sort_by { |e| -e.count }.collect { |e| e.attributes.slice("name", "count") }
      #
      #   hash
    end

    # http://localhost:3000/w.json?query=devuser1&format_type=user
    # https://www.shogi-extend.com/w.json?query=kinakom0chi&format_type=user
    def to_hash
      retv = {}

      retv[:user] = { key: user.key }

      retv[:rules_hash] = rules_hash

      # 直近勝敗リスト
      retv[:judge_keys] = current_memberships.collect { |e| e.judge_key }

      # 勝敗数
      retv[:judge_counts] = judge_counts

      # # 勝率
      # if current_memberships.present?
      #   retv[:win_rate] = judge_counts["win"].fdiv(current_memberships.count)
      # end

      retv[:day_list] = day_list
      retv[:buki_list] = buki_list

      retv
    end
  end
end
