# -*- coding: utf-8 -*-

module Ppl
  class User < ApplicationRecord
    class << self
      def [](name)
        find_by(name: name)
      end
    end

    has_many :memberships, dependent: :destroy   # 対局時の情報(複数)
    has_many :league_seasons, through: :memberships     # 対局(複数)

    with_options class_name: "Ppl::Membership", optional: true do
      belongs_to :memberships_first
      belongs_to :memberships_last
      belongs_to :promotion_membership
    end

    # 最優先で「昇段している人」「昇段していない人」の順にする
    # 非常にわかりにくいが promotion_season_number IS NULL で値があれば false つまり 0 になるため上にくる
    # そのあとで promotion_season_number: asc なので昇段している中ではなるべく先輩から表示する
    # このようにすることで、期を絞ったときその期で昇段した人が上にくるのでわかりやすい
    scope :table_order, -> { order(Arel.sql("promotion_season_number IS NULL"), promotion_season_number: :asc, promotion_win: :desc, runner_up_count: :desc, age_min: :asc, memberships_count: :asc) }

    # 最近昇段した人ほど手前にくる
    scope :link_order,  -> { order(promotion_season_number: :desc, promotion_win: :desc, runner_up_count: :desc, age_min: :asc, memberships_count: :asc) }

    scope :plus_minus_search, -> query do
      scope = all
      SimpleQueryParser.parse(query.to_s).each do |plus, queries|
        queries.each do |query|
          sanitized = ActiveRecord::Base.sanitize_sql_like(query.downcase)
          scope = scope.where("#{plus ? '' : 'NOT'} (LOWER(name) LIKE ?)", "%#{sanitized}%")
        end
      end
      scope
    end

    scope :search, -> (params = {}) { UserSearch.call(all, params) }

    normalizes :name, with: -> e { NameNormalizer.normalize(e) }

    before_validation do
      self.runner_up_count ||= 0
      self.win_max ||= 0
    end

    # 昇段または次点2つで権利を獲得したか？
    # ・次点2つの場合は昇段したか
    def promoted_or_rights
      promotion_membership_id || runner_up_count >= 2
    end

    def promotion_age
      promotion_membership&.age
    end

    def season_number_range
      season_number_min..season_number_max
    end
  end
end
