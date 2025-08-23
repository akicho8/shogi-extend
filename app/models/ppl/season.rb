# -*- coding: utf-8 -*-

# == Schema Information ==
#
# League season (ppl_seasons as Ppl::Season)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A     |
# | position   | 順序     | integer(4)  |             |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

module Ppl
  class Season < ApplicationRecord
    class << self
      def setup(options = {})
        if Rails.env.local?
          Ppl::Updater.resume_crawling(season_key_begin: "S62", limit: 2)
          Ppl::Updater.resume_crawling(season_key_begin: "30",  limit: 2)
        else
          Ppl::Updater.resume_crawling(options)
        end
      end

      def [](key)
        find_by(key: key)
      end

      def fetch(key)
        find_by!(key: key)
      end

      def latest_key
        oldest_order.first&.key
      end

      def latest_key_or_base
        latest_key || AntiquitySpider.accept_range.min
      end
    end

    acts_as_list touch_on_update: false, top_of_list: 0

    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships

    normalizes :key, with: -> e { e.to_s }

    scope :latest_order, -> { order(position: :desc) }
    scope :oldest_order, -> { order(position: :asc)  }
  end
end
