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
        user_ids = target_users.flat_map { |user| user.league_seasons.flat_map(&:user_ids) }
        scope = scope.where(id: user_ids)
      end

      # この期の同期を抽出する (複数指定可)
      if target_league_seasons.present?
        user_ids = target_league_seasons.flat_map { |league_season| league_season.user_ids }
        scope = scope.where(id: user_ids)
      end

      scope = scope.includes(memberships: [:user, :league_season, :result])
      scope = scope.table_order
    end

    def target_users
      @target_users ||= User.where(name: params[:name_rel].to_s.scan(/\S+/))
    end

    def target_season_numbers
      @target_season_numbers ||= params[:season_number_rel].to_s.scan(/\d+/).collect(&:to_i).to_set
    end

    def target_league_seasons
      @target_league_seasons ||= LeagueSeason.where(season_number: target_season_numbers)
    end
  end
end
