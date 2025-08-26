# frozen-string-literal: true

module Ppl
  class UserSearch
    attr_reader :all
    attr_reader :params

    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(all, params = {})
      @all = all
      @params = params
    end

    def call
      scope = all.plus_minus_search(params[:query])

      # この棋士たちの同期を抽出する (氏名完全一致・複数指定可)
      if target_users.present?
        if false
          # 遅い。(ユーザー数 * 所属シーズン数) のSQLが走ってしまう
          user_ids = target_users.flat_map { |user| user.seasons.flat_map(&:user_ids) }
        else
          # 速い
          season_ids = Membership.where(user_id: target_users).distinct.pluck(:season_id)
          user_ids = Membership.where(season_id: season_ids).distinct.pluck(:user_id)
        end
        scope = scope.where(id: user_ids)
      end

      # この師匠の弟子を抽出する
      if target_mentors.present?
        scope = scope.where(mentor: target_mentors)
      end

      # この期の同期を抽出する (複数指定可)
      if target_seasons.present?
        if false
          # 遅い
          user_ids = target_seasons.flat_map { |season| season.user_ids }
        else
          # 速い
          user_ids = Membership.where(season_id: target_seasons).distinct.pluck(:user_id)
        end
        scope = scope.where(id: user_ids)
      end

      # order で ranks.position を使っているかつ user.rank で引いているため joins でも preload でもなく includes を使う
      scope = scope.includes(:rank)

      scope = scope.preload(mentor: nil, memberships: { user: nil, season: nil, result: nil })
      scope = scope.preload({
          memberships_first:    { season: nil },
          memberships_last:     { season: nil },
          promotion_membership: { season: nil },
        })
      scope = scope.table_order
    end

    # to_a は副SQLにしないためわざとしている
    def target_users
      @target_users ||= User.where(name: StringToolkit.split(params[:user_name].to_s)).to_a
    end

    def target_mentors
      @target_mentors ||= Mentor.where(name: StringToolkit.split(params[:mentor_name].to_s)).to_a
    end

    def target_seasons
      @target_seasons ||= Season.where(key: StringToolkit.split(params[:season_key].to_s)).to_a
    end
  end
end
