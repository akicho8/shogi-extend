# idを特定してからall_tag_countsした方が速いのか検証 → 結果:変わらないというか気持ち程度は速くなっている
#
#   user1 = Swars::User.create!
#   user2 = Swars::User.create!
#   100.times do
#     battle = Swars::Battle.new
#     battle.memberships.build(user: user1)
#     battle.memberships.build(user: user2)
#     battle.save!
#   end
#
#   p Swars::Battle.count             # => 2529
#
#   user = Swars::User.first
#
#   s1 = user.memberships
#   s1 = s1.joins(:battle)
#   s1 = s1.where(Swars::Battle.arel_table[:win_user_id].not_eq(nil)) # 勝敗が必ずあるもの
#   s1 = s1.order(Swars::Battle.arel_table[:battled_at].desc)         # 直近のものから取得
#   s1 = s1.includes(:battle)
#   s1 = s1.limit(50)
#
#   s2 = user.memberships.where(id: s1.pluck(:id))
#
#   require 'active_support/core_ext/benchmark'
#
#   f = -> s { s.all_tag_counts(at_least: 1, order: "count desc") }
#   f.(s1)                           # => #<ActiveRecord::Relation [#<ActsAsTaggableOn::Tag id: 6, name: "居飛車", taggings_count: 5058>, #<ActsAsTaggableOn::Tag id: 29, name: "居玉", taggings_count: 7587>, #<ActsAsTaggableOn::Tag id: 115, name: "嬉野流", taggings_count: 5058>]>
#   f.(s2)                           # => #<ActiveRecord::Relation [#<ActsAsTaggableOn::Tag id: 6, name: "居飛車", taggings_count: 5058>, #<ActsAsTaggableOn::Tag id: 29, name: "居玉", taggings_count: 7587>, #<ActsAsTaggableOn::Tag id: 115, name: "嬉野流", taggings_count: 5058>]>
#
#   require "active_support/core_ext/benchmark"
#   def _; "%7.2f ms" % Benchmark.ms { 2000.times { yield } } end
#   p _ { f.(s1) } # => "4051.89 ms"
#   p _ { f.(s2) } # => "3771.33 ms"
#   # >> "4051.89 ms"
#   # >> "3771.33 ms"

module Swars
  class UserInfo
    attr_accessor :user
    attr_accessor :params

    cattr_accessor(:default_params) {
      {
        :max    => 50, # データ対象直近n件
        :ox_max => 20, # 表示勝敗直近n件
      }
    }

    def initialize(user, params = {})
      @user = user
      @params = default_params.merge(params)
    end

    # http://localhost:3000/w.json?query=devuser1&format_type=user
    # https://www.shogi-extend.com/w.json?query=kinakom0chi&format_type=user
    def to_hash
      retv = {}

      retv[:user] = { key: user.key }

      retv[:rules_hash] = rules_hash

      # 直近勝敗リスト
      retv[:judge_keys] = current_scope0.limit(current_ox_max).collect(&:judge_key).reverse

      # トータル勝敗数
      retv[:judge_counts] = judge_counts_wrap(current_scope.group("judge_key").count)

      # # 勝率
      # if current_memberships.present?
      #   retv[:win_rate] = judge_counts["win"].fdiv(current_memberships.count)
      # end

      retv[:day_list] = day_list
      retv[:buki_list] = buki_list
      retv[:jakuten_list] = jakuten_list
      retv[:medal_list] = medal_list

      retv
    end

    private

    def current_max
      (params[:max].presence || default_params[:max]).to_i
    end

    def current_ox_max
      (params[:ox_max].presence || default_params[:ox_max]).to_i
    end

    def current_scope5(s)
      s = s.joins(:battle)
      s = s.where(Swars::Battle.arel_table[:win_user_id].not_eq(nil)) # 勝敗が必ずあるもの
      s = s.order(Swars::Battle.arel_table[:battled_at].desc)         # 直近のものから取得
    end

    def current_scope0
      s = user.memberships
      s = current_scope5(s)
      s = s.includes(:battle)
    end

    let :current_scope do
      s = current_scope0
      s = s.limit(current_max)
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
      group = current_scope.group_by { |e| e.battle.battled_at.midnight } # FIXME
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
      jakuten_list_for(user.memberships)
    end

    def jakuten_list_for(memberships, options = {})
      s = memberships
      s = current_scope5(s)
      s = s.limit(current_max)

      s2 = memberships.where(id: s.collect(&:id))

      count = s.count
      tags = s.tag_counts_on(:attack_tags, at_least: 1, order: "count desc")
      tags.collect do |tag|
        hash = {}
        hash[:tag] = tag.attributes.slice("name", "count")
        judge_counts = judge_counts_wrap(s2.tagged_with(tag.name, on: :attack_tags).group("judge_key").count) # => {"win" => 1, "lose" => 2}
        if options[:judge_flip]
          judge_counts = judge_counts.keys.zip(judge_counts.values.reverse).to_h   # => {"win" => 2, "lose" => 1}    ; 自分視点に変更
        end
        hash[:judge_counts] = judge_counts
        hash[:appear_ratio] = tag.count.fdiv(count)
        hash
      end
    end

    def jakuten_list
      jakuten_list_for(user.op_memberships, judge_flip: true)
    end

    def medal_list
      medals = []

      # current_scope.tag_counts_on(:attack_tags, at_least: 1, order: "count desc")
      ids = current_scope.pluck(:id)
      count = ids.count

      # TODO: 分けたほうがはやいのか、一度の方がいいのか検証する
      s2 = current_scope
      s2 = s2.where(id: ids)

      all_tag_counts = s2.all_tag_counts(at_least: 1)
      all_hash = all_tag_counts.inject(Hash.new(0)) { |a, e| a.merge(e.name => e.count) }

      # note_tag_counts = s2.tag_counts_on(:note_tags, at_least: 1)
      # hash = note_tag_counts.inject(Hash.new(0)) { |a, e| a.merge(e.name => e.count) }

      total = all_hash["居飛車"] + all_hash["振り飛車"]
      ratio = all_hash["居飛車"].fdiv(total)
      threshold = 0.7
      case
      when ratio >= threshold
        medals << { method: "tag", name: "居", type: "is-light" }
      when ratio <= 1.0 - threshold
        medals << { method: "tag", name: "振", type: "is-light" }
      else
        medals << { method: "tag", name: "A", type: "is-dark" }
      end

      if params[:debug]
        medals << { method: "tag", name: "X", type: "is-white" }
        medals << { method: "tag", name: "X", type: "is-black" }
        medals << { method: "tag", name: "X", type: "is-light" }
        medals << { method: "tag", name: "X", type: "is-dark" }
        medals << { method: "tag", name: "X", type: "is-info" }
        # medals << { method: "tag", name: "X", type: "is-success" }
        medals << { method: "tag", name: "X", type: "is-warning" }
        # medals << { method: "tag", name: "X", type: "is-danger" }
        medals << { method: "tag", name: "💩", type: "is-white" }
        medals << { method: "raw", name: "💩" }
        medals << { method: "icon", name: "link", type: "is-warning" }
      end

      if all_hash["嬉野流"].fdiv(count) >= 0.25
        medals << { method: "tag", name: "嬉", type: "is-light" }
      end

      medals

      # ロケット
      # 角換わり

      # s = memberships
      # s = current_scope5(s)
      # s = s.limit(current_max)
      #
      # s2 = memberships.where(id: s.collect(&:id))
      #
      # count = s.count
      # tags = s.tag_counts_on(:attack_tags, at_least: 1, order: "count desc")
      # tags.collect do |tag|
      #   hash = {}
      #   hash[:tag] = tag.attributes.slice("name", "count")
      #   judge_counts = judge_counts_wrap(s2.tagged_with(tag.name, on: :attack_tags).group("judge_key").count) # => {"win" => 1, "lose" => 2}
      #   if options[:judge_flip]
      #     judge_counts = judge_counts.keys.zip(judge_counts.values.reverse).to_h   # => {"win" => 2, "lose" => 1}    ; 自分視点に変更
      #   end
      #   hash[:judge_counts] = judge_counts
      #   hash[:appear_ratio] = tag.count.fdiv(count)
      #   hash
      # end
    end

    # judge_counts_wrap("win" => 1) # => {"win" => 1, "lose" => 0}
    def judge_counts_wrap(hash)
      {"win" => 0, "lose" => 0}.merge(hash)
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
