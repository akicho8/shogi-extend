# frozen-string-literal: true

module Ppl
  class User < ApplicationRecord
    PROMOTABLE_RUNNER_UP_COUNT = 2 # 昇段の権利を取得できる次点の数

    class << self
      def [](name)
        find_by(name: name)
      end

      def fetch(name)
        find_by!(name: name)
      end
    end

    has_many :memberships, dependent: :destroy      # 対局時の情報(複数)
    has_many :league_seasons, through: :memberships # 対局(複数)

    belongs_to :mentor, counter_cache: true, optional: true # 師匠 (いない人もいる)

    custom_belongs_to :rank, ar_model: Rank, st_model: RankInfo, default: :active_member # 昇段→フリ→現役→退会

    with_options class_name: "Ppl::Membership", optional: true do
      belongs_to :memberships_first    # 所属開始したときの時期
      belongs_to :memberships_last     # 所属終了したときの時期
      belongs_to :promotion_membership # 昇段したときの時期
    end

    # 最優先で「昇段している人」「昇段していない人」の順にする
    # 非常にわかりにくいが promotion_season_number IS NULL で値があれば false つまり 0 になるため上にくる
    # そのあとで promotion_season_number: asc なので昇段している中ではなるべく先輩から表示する
    # このようにすることで、期を絞ったときその期で昇段した人が上にくるのでわかりやすい
    scope :table_order,  -> {
      order([
          Rank.arel_table[:position].asc,
          {promotion_season_number: :asc},
          {promotion_win: :desc},
          {runner_up_count: :desc},
          {age_min: :asc},
          {memberships_count: :asc},
        ])
      }

    # 最近昇段した人ほど手前にくる
    scope :link_order,  -> {
      order([
          Rank.arel_table[:position].asc,
          {promotion_season_number: :desc},
          {promotion_win: :desc},
          {runner_up_count: :desc},
          {age_min: :asc},
          {memberships_count: :asc},
        ])
      }

    scope :json_order, -> { link_order }

    scope :plus_minus_search, -> query do
      scope = all
      SimpleQueryParser.parse(query.to_s).each do |plus, queries|
        queries.each do |query|
          sanitized = ActiveRecord::Base.sanitize_sql_like(query.downcase)
          scope = scope.where("#{plus ? '' : 'NOT'} (LOWER(#{table_name}.name) LIKE ?)", "%#{sanitized}%")
        end
      end
      scope
    end

    scope :search, -> (params = {}) { UserSearch.call(all, params) }

    normalizes :name, with: -> e { NameNormalizer.normalize(e) }

    before_validation do
      self.runner_up_count ||= 0

      self.win_max ||= 0
      self.total_win ||= 0
      self.total_lose ||= 0
      self.win_ratio ||= 0

      denominator = total_win + total_lose
      if denominator.nonzero?
        self.win_ratio = total_win.fdiv(denominator)
      end
    end

    with_options presence: true do
      validates :name
    end

    with_options allow_blank: true do
      validates :name, uniqueness: true
    end

    # 「昇段」or「次点2つ」か？
    def promoted_or_rights
      promotion_membership_id || promotion_by_runner_up_count?
    end

    # 「次点2つ」によって昇段の権利を得たか？
    def promotion_by_runner_up_count?
      runner_up_count >= PROMOTABLE_RUNNER_UP_COUNT
    end

    # 昇段した年齢
    def promotion_age
      promotion_membership&.age
    end

    # 所属した範囲
    def season_number_range
      season_number_min..season_number_max
    end

    # 退会した？ (連盟が「降」を書かないため退会したのか降段なのかわからない)
    def deactivated?
      deactivated_season_number
    end

    # 現役会員と思われる？
    def active?
      !deactivated_season_number
    end

    # 状態
    def rank_key_without_rank
      if promotion_membership
        if promotion_membership.result_key == "promotion"
          :true_professional
        else
          :substitute_professional
        end
      elsif deactivated_season_number
        :resigned
      else
        :active_member
      end
    end

    # 退会することにしたシーズンを得る
    def update_deactivated_season_number
      scope = Ppl::LeagueSeason.where(Ppl::LeagueSeason.arel_table[:season_number].gt(season_number_max)).oldest_order
      scope = scope.includes(:users)
      league_season = scope.first

      if league_season
        if league_season.users.include?(self)
          # 次のシーズンに参加している (シーズン > season_number_max としているのでここにくることはない)
          raise "must not happen"
        else
          # 次のシーズンがあるのに参加していないということは season_number_max を最後に退会したということ
          self.deactivated_season_number = season_number_max
        end
      else
        # 次のシーズンがないということは最新のシーズン所属している
        self.deactivated_season_number = nil
      end

      self.rank_key = rank_key_without_rank

      save!
    end
  end
end
