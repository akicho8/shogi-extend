# -*- coding: utf-8 -*-

# == Schema Information ==
#
# League (ppl_leagues as Ppl::League)
#
# |------------+------------+------------+-------------+------+-------|
# | name       | desc       | type       | opts        | refs | index |
# |------------+------------+------------+-------------+------+-------|
# | id         | ID         | integer(8) | NOT NULL PK |      |       |
# | generation | Generation | integer(4) | NOT NULL    |      | A     |
# | created_at | 作成日時   | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime   | NOT NULL    |      |       |
# |------------+------------+------------+-------------+------+-------|

module Ppl
  class League < ApplicationRecord
    class << self
      def setup(options = {})
        if Rails.env.local?
          Ppl::Updater.resume_crawling(generations: (58..60))
        else
          Ppl::Updater.resume_crawling(options)
        end
      end

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
  end
end
