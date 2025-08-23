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
        user_ids = target_users.flat_map { |user| user.seasons.flat_map(&:user_ids) }
        scope = scope.where(id: user_ids)
      end

      # この師匠の弟子を抽出する
      if target_mentors.present?
        scope = scope.joins(:mentor).merge(target_mentors)
      end

      # この期の同期を抽出する (複数指定可)
      if target_seasons.present?
        user_ids = target_seasons.flat_map { |season| season.user_ids }
        scope = scope.where(id: user_ids)
      end

      scope = scope.includes(rank: nil, mentor: nil, memberships: { user: nil, season: nil, result: nil })
      scope = scope.table_order
    end

    def target_users
      @target_users ||= User.where(name: StringToolkit.split(params[:name].to_s))
    end

    def target_mentors
      @target_mentors ||= Mentor.where(name: StringToolkit.split(params[:mentor_name].to_s))
    end

    def target_seasons
      @target_seasons ||= Season.where(key: StringToolkit.split(params[:season_key].to_s))
    end
  end
end
