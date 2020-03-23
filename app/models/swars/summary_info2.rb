module Swars
  class SummaryInfo2
    attr_reader :user

    def initialize(user)
      @user = user
    end

    # http://localhost:3000/w.json?query=devuser1&format_type=user
    # https://www.shogi-extend.com/w.json?query=kinakom0chi&format_type=user
    def to_hash
      retv = {}

      retv[:user] = { key: user.key }

      retv[:rules_hash] = rules_hash

      # 直近勝敗リスト
      retv[:judge_keys] = current_scope0.limit(10).collect(&:judge_key).reverse

      # トータル勝敗数
      retv[:judge_counts] = judge_counts_normalize(current_scope.group("judge_key").count)

      # # 勝率
      # if current_memberships.present?
      #   retv[:win_rate] = judge_counts["win"].fdiv(current_memberships.count)
      # end

      retv[:day_list] = day_list
      retv[:buki_list] = buki_list
      retv[:jakuten_list] = jakuten_list

      retv
    end

    private

    def current_scope0
      s = user.memberships
      s = s.joins(:battle).includes(:battle)
      s = s.where(Swars::Battle.arel_table[:win_user_id].not_eq(nil)) # 勝敗が必ずあるもの
      s = s.order(Swars::Battle.arel_table[:battled_at].desc)         # 直近のものから取得
    end

    let :current_scope do
      s = current_scope0
      s = s.limit(50)
    end

    let :current_memberships do
      current_scope.to_a
    end

    # memberships が配列になっているとき用
    def judge_counts_of(memberships)
      group = memberships.group_by(&:judge_key)
      ["win", "lose"].inject({}) { |a, e| a.merge(e => (group[e] || []).count) }
    end

    def rules_hash
      # grade はここだけで定義うる
      group = current_memberships.group_by { |e| e.battle.rule_key }
      Swars::RuleInfo.inject({}) do |a, e|
        hash = {}
        hash[:rule_name] = e.name
        if membership = (group[e.key.to_s] || []).first
          hash[:grade_name] = membership.grade.name # grade へのアクセスはここだけなので includes しない方がよい
        else
          hash[:grade_name] = nil
        end
        a.merge(e.key => hash)
      end
    end

    def day_list
      group = current_scope.group_by { |e| e.battle.battled_at.midnight }
      group.collect do |battled_at, memberships|

        hash = {}
        hash[:battled_at]   = battled_at
        hash[:day_color]    = day_color_of(battled_at)
        hash[:judge_counts] = judge_counts_of(memberships)

        s = Swars::Membership.where(id: memberships.collect(&:id))

        # hash2 = [:attack_tags, :defense_tags].inject({}) do |a, tags_method|
        #   tags = s.tag_counts_on(tags_method, at_least: 1, order: "count desc")
        #   a.merge(tags_method => tags.collect { |e| e.attributes.slice("name", "count") })
        # end
        # hash.update(hash2)

        # 戦法と囲いをまぜて一番使われている順にN個
        if false
          tags = [:attack_tags, :defense_tags].flat_map do |tags_method|
            s.tag_counts_on(tags_method, at_least: 1, order: "count desc")
          end
          tags = tags.sort_by { |e| -e.count }
          hash[:all_tags] = tags.take(1).collect { |e| e.attributes.slice("name", "count") }
        end

        # 戦法と囲いそれぞれ一番使われているもの1個ずつ計2個
        hash[:all_tags] = [:attack_tags, :defense_tags].flat_map { |tags_method|
          s.tag_counts_on(tags_method, at_least: 1, order: "count desc", limit: 1)
        }.collect{ |e| e.attributes.slice("name", "count") }

        hash
      end
    end

    def buki_list
      jakuten_list_for(user.memberships, win_lose_filp: false)
    end

    def jakuten_list_for(memberships, options = {})
      s = memberships
      s = s.joins(:battle)
      s = s.where(Swars::Battle.arel_table[:win_user_id].not_eq(nil)) # 勝敗が必ずあるもの
      s = s.order(Swars::Battle.arel_table[:battled_at].desc)         # 直近のものから取得
      s = s.limit(50)

      s2 = memberships.where(id: s.collect(&:id))

      count = s.count
      tags = s.tag_counts_on(:attack_tags, at_least: 1, order: "count desc")
      tags.collect do |tag|
        hash = {}
        hash[:tag] = tag.attributes.slice("name", "count")
        judge_counts = judge_counts_normalize(s2.tagged_with(tag.name, on: :attack_tags).group("judge_key").count) # => {"win" => 1, "lose" => 2}
        if options[:win_lose_filp]
          judge_counts = judge_counts.keys.zip(judge_counts.values.reverse).to_h   # => {"win" => 2, "lose" => 1}    ; 自分視点に変更
        end
        hash[:judge_counts] = judge_counts
        hash[:use_ratio] = tag.count.fdiv(count)
        hash
      end
    end

    def jakuten_list
      jakuten_list_for(user.op_memberships, win_lose_filp: true)
    end

    # judge_counts_normalize("win" => 1) # => {"win" => 1, "lose" => 0}
    def judge_counts_normalize(v)
      {"win" => 0, "lose" => 0}.merge(v)
    end

    def day_color_of(t)
      case
      when t.sunday?
        "danger"
      when t.saturday?
        "info"
      when HolidayJp.holiday?(t)
        "danger"
      end
    end
  end
end
