# -*- frozen_string_literal: true -*-
#
# id を特定してから all_tag_counts した方が速いのか検証 → 結果:変わらないというか気持ち程度は速くなっている
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
#   s2 = user.memberships.where(id: s1.ids)
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
#   p _ { f.(s2) } # => "3771.33 ms" ← 若干速くなっている
#   # >> "4051.89 ms"
#   # >> "3771.33 ms"

module Swars
  class UserInfo
    attr_accessor :user
    attr_accessor :params

    cattr_accessor(:max_of_max) { 200 }

    cattr_accessor(:default_params) {
      {
        :sample_max => 50, # データ対象直近n件
        :ox_max     => 17, # 表示勝敗直近n件
      }
    }

    def initialize(user, params = {})
      @user = user
      @params = default_params.merge(params)
    end

    # http://localhost:3000/w.json?query=devuser1&format_type=user
    # http://localhost:3000/w.json?query=devuser1&format_type=user&debug=true
    # https://www.shogi-extend.com/w.json?query=kinakom0chi&format_type=user
    def to_hash
      {}.tap do |hash|
        hash[:onetime_key] = SecureRandom.hex # vue.js の :key に使うため

        hash[:sample_max] = sample_max      # サンプル数(棋譜一覧で再検索するときに "sample:n" として渡す)

        hash[:user] = { key: user.key }

        hash[:rules_hash] = rules_hash

        # トータル勝敗数
        hash[:judge_counts] = judge_counts

        # 直近勝敗リスト
        hash[:judge_keys] = current_scope_base.limit(current_ox_max).pluck(:judge_key).reverse

        hash[:medal_list] = medal_list.to_a
        hash[:debug_hash] = medal_list.to_debug_hash
        hash[:win_lose_streak_max_hash] = medal_list.win_lose_streak_max_hash

        ################################################################################

        hash[:every_day_list]       = every_day_list
        hash[:every_grade_list]     = every_grade_list
        hash[:every_my_attack_list] = every_my_attack_list
        hash[:every_vs_attack_list] = every_vs_attack_list
        hash[:every_my_defense_list] = every_my_defense_list
        hash[:every_vs_defense_list] = every_vs_defense_list
      end
    end

    def judge_counts
      @judge_counts ||= judge_counts_wrap(ids_scope.group(:judge_key).count)
    end

    def medal_list
      @medal_list ||= MedalList.new(self)
    end

    def current_scope
      s = current_scope_base
      s = s.limit(sample_max)
    end

    # all_tag_counts を使う場合 current_scope の条件で引いたもので id だけを取得してSQLを作り直した方が若干速い
    # また group するときも order が入っていると MySQL では group に order のカラムも含めないと正しく動かなくてわけわからんんことになるのでそれの回避
    def ids_scope
      Swars::Membership.where(id: current_scope.ids) # 再スコープ化
    end

    def real_count
      @real_count ||= current_scope.count
    end

    def at_least_value
      # 1だったら指定しなくていいんじゃね？
      # 1
    end

    def sample_max
      @sample_max ||= [(params[:sample_max].presence || default_params[:sample_max]).to_i, max_of_max].min
    end

    def every_grade_list
      s = user.op_memberships
      s = condition_add(s)
      s = s.limit(sample_max)
      denominator = s.count

      s = Swars::Membership.where(id: s.ids) # 再スコープ化

      s = s.joins(:grade).group(Swars::Grade.arel_table[:key]) # 段級と
      s = s.group(:judge_key)                                  # 勝ち負けでグループ化
      s = s.order(Swars::Grade.arel_table[:priority])          # 相手が強い順
      hash = s.count                                           # => {["九段", "lose"]=>2, ["九段", "win"]=>1}

      counts = {}
      hash.each do |(grade_key, win_or_lose), count|
        counts[grade_key] ||= { win: 0, lose: 0 }
        judge_info = JudgeInfo.fetch(win_or_lose)
        counts[grade_key][judge_info.flip.key] = count # 勝敗反転
      end

      counts # => {"九段"=>{:win=>2, :lose=>1}, "初段"=>{:win=>1, :lose=>0}}

      ary = counts.collect do |k, v|
        total = v.sum { |_, c| c } # total = v[:win] + v[:lose]
        { grade_name: k, judge_counts: v, appear_ratio: total.fdiv(denominator) }
      end

      ary # => [{:grade_name=>"九段", :judge_counts=>{:win=>2, :lose=>1}}, {:grade_name=>"初段", :judge_counts=>{:win=>1, :lose=>0}}]
    end

    def condition_add(s)
      s = s.joins(:battle)
      s = s.merge(Swars::Battle.win_lose_only) # 勝敗が必ずあるもの
      s = s.merge(Swars::Battle.newest_order)  # 直近のものから取得
    end

    private

    def current_ox_max
      [(params[:ox_max].presence || default_params[:ox_max]).to_i, 100].min
    end

    def current_scope_base
      s = user.memberships
      s = condition_add(s)
    end

    # memberships が配列になっているとき用
    def judge_counts_of(memberships)
      group = memberships.group_by(&:judge_key)
      ["win", "lose"].inject({}) { |a, e| a.merge(e => (group[e] || []).count) }
    end

    def rules_hash
      group = current_scope.includes(:battle).group_by { |e| e.battle.rule_key }

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

    def every_day_list
      group = current_scope.includes(:battle).group_by { |e| e.battle.battled_at.midnight }
      group.collect do |battled_at, memberships|

        hash = {}
        hash[:battled_on]   = battled_at.to_date
        hash[:day_type]    = day_type_for(battled_at)
        hash[:judge_counts] = judge_counts_of(memberships)

        s = Swars::Membership.where(id: memberships.collect(&:id)) # 再スコープ化

        # 戦法と囲いをまぜて一番使われている順にN個表示する場合
        if false
          tags = [:attack_tags, :defense_tags].flat_map do |tags_method|
            s.tag_counts_on(tags_method, at_least: at_least_value, order: "count desc")
          end
          tags = tags.sort_by { |e| -e.count }
          hash[:all_tags] = tags.take(2).collect { |e| e.attributes.slice("name", "count") }
        end

        # 戦法と囲いそれぞれ一番使われているもの1個ずつ計2個
        if true
          hash[:all_tags] = [:attack_tags, :defense_tags].flat_map { |tags_method|
            s.tag_counts_on(tags_method, at_least: at_least_value, order: "count desc", limit: 1)
          }.collect{ |e| e.attributes.slice("name", "count") }
        end

        hash
      end
    end

    # 戦法 * 自分
    def every_my_attack_list
      list_build(user.memberships, context: :attack_tags, judge_flip: false)
    end

    # 戦法 * 相手
    def every_vs_attack_list
      list_build(user.op_memberships, context: :attack_tags, judge_flip: true)
    end

    # 囲い * 自分
    def every_my_defense_list
      list_build(user.memberships, context: :defense_tags, judge_flip: false)
    end

    # 囲い * 相手
    def every_vs_defense_list
      list_build(user.op_memberships, context: :defense_tags, judge_flip: true)
    end

    def list_build(memberships, options = {})
      s = memberships
      s = condition_add(s)
      s = s.limit(sample_max)
      denominator = s.count

      # tag_counts_on をシンプルなSQLで実行させると若干速くなるが、それのためではなく
      # sample_max 件で最初に絞らないといけない
      s = Swars::Membership.where(id: s.ids) # 再スコープ化

      tags = s.tag_counts_on(options[:context], at_least: at_least_value, order: "count desc") # FIXME: tag_counts_on.group("name").group("judge_key") のようにできるはず
      tags.collect do |tag|
        {}.tap do |hash|
          hash[:tag] = tag.attributes.slice("name", "count")  # 戦法名
          hash[:appear_ratio] = tag.count.fdiv(denominator)         # 使用率, 遭遇率

          # 勝ち負け数
          c = judge_counts_wrap(s.tagged_with(tag.name, on: options[:context]).group("judge_key").count) # => {"win" => 1, "lose" => 0}
          if options[:judge_flip]
            c["win"], c["lose"] = c["lose"], c["win"] # => {"win" => 0, "lose" => 1}    ; 自分視点に変更
          end
          hash[:judge_counts] = c
        end
      end
    end

    # judge_counts_wrap({})         # => {"win" => 0, "lose" => 0}
    # judge_counts_wrap("win" => 1) # => {"win" => 1, "lose" => 0}
    def judge_counts_wrap(hash)
      {"win" => 0, "lose" => 0}.merge(hash) # JudgeInfo.inject({}) { |a, e| a.merge(e.key.to_s => 0) }.merge(hash)
    end

    def day_type_for(t)
      case
      when t.sunday?
        :danger
      when t.saturday?
        :info
      when HolidayJp.holiday?(t)
        :danger
      end
    end
  end
end
