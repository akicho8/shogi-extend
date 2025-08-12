# -*- coding: utf-8 -*-

module Tsl
  class User < ApplicationRecord
    has_many :memberships, dependent: :destroy   # 対局時の情報(複数)
    has_many :leagues, through: :memberships     # 対局(複数)

    with_options class_name: "Tsl::Membership", optional: true do
      belongs_to :min_membership
      belongs_to :max_membership
      belongs_to :promotion_membership
    end

    scope :link_order,  -> { order(promotion_generation: :desc, runner_up_count: :desc, min_age: :asc, memberships_count: :asc) }
    scope :table_order, -> { order(promotion_generation: :desc, runner_up_count: :desc, min_age: :asc, memberships_count: :asc) }

    scope :plus_minus_search, -> query do
      scope = all
      SimpleQueryParser.parse(query.to_s).each do |plus, queries|
        queries.each do |query|
          case
          when query == "all"
          when query.match?(/\A\d+\z/)
            if league = Tsl::League.find_by(generation: query)
              if plus
                scope = scope.where(id: league.user_ids)
              else
                scope = scope.where.not(id: league.user_ids)
              end
            end
          else
            sanitized = ActiveRecord::Base.sanitize_sql_like(query.downcase)
            scope = scope.where("#{plus ? '' : 'NOT'} (LOWER(name) LIKE ?)", "%#{sanitized}%")
          end
        end
      end
      scope
    end

    normalizes :name, with: -> e { NameNormalizer.normalize(e) }

    before_validation do
      self.runner_up_count ||= 0
    end

    def shoudan_p
      promotion_membership || runner_up_count >= 2
    end

    # シーズン generation を含まないこれまでの在籍回数
    def seat_count_lt(generation)
      memberships.joins(:league).where(League.arel_table[:generation].lt(generation)).count
    end

    def promotion_age
      promotion_membership&.age
    end
  end
end
