# -*- coding: utf-8 -*-

# == Schema Information ==
#
# LeagueSeason (ppl_league_seasons as Ppl::LeagueSeason)
#
# |------------+------------+------------+-------------+------+-------|
# | name       | desc       | type       | opts        | refs | index |
# |------------+------------+------------+-------------+------+-------|
# | id         | ID         | integer(8) | NOT NULL PK |      |       |
# | season_number | SeasonNumber | integer(4) | NOT NULL    |      | A     |
# | created_at | 作成日時   | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime   | NOT NULL    |      |       |
# |------------+------------+------------+-------------+------+-------|

module Ppl
  class LeagueSeason < ApplicationRecord
    class << self
      def setup(options = {})
        if Rails.env.local?
          Ppl::Updater.resume_crawling(season_numbers: (58..60))
        else
          Ppl::Updater.resume_crawling(options)
        end
      end

      def season_number_min
        oldest_order.first&.season_number
      end

      def season_number_max
        oldest_order.last&.season_number
      end

      def season_number_range
        (season_number_min..season_number_max)
      end
    end

    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships

    scope :latest_order, -> { order(season_number: :desc) }
    scope :oldest_order, -> { order(season_number: :asc)  }
  end
end
