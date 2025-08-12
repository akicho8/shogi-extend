# -*- coding: utf-8 -*-

# == Schema Information ==
#
# League (tsl_leagues as Tsl::League)
#
# |------------+------------+------------+-------------+------+-------|
# | name       | desc       | type       | opts        | refs | index |
# |------------+------------+------------+-------------+------+-------|
# | id         | ID         | integer(8) | NOT NULL PK |      |       |
# | generation | Generation | integer(4) | NOT NULL    |      | A     |
# | created_at | 作成日時   | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime   | NOT NULL    |      |       |
# |------------+------------+------------+-------------+------+-------|

module Tsl
  class League < ApplicationRecord
    class << self
      def min_generation
        oldest_order.first&.generation
      end

      def max_generation
        oldest_order.last&.generation
      end

      def generation_range
        (min_generation..max_generation)
      end
    end

    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships

    scope :newest_order, -> { order(generation: :desc) }
    scope :oldest_order, -> { order(generation: :asc)  }

    def source_url
      Spider.new(generation: generation).source_url
    end

    # 最新か？
    def newest_record?
      self.class.newest_order.first == self
    end
  end
end
