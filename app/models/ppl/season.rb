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
          Ppl::Updater.resume_crawling(start: "S62", limit: 2)
          Ppl::Updater.resume_crawling(start: "30",  limit: 2)
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
        latest_order.first&.key
      end

      def latest_or_base_key
        latest_key || SeasonKeyVo[AntiquitySpider.accept_range.min]
      end
    end

    composed_of :key, class_name: "Ppl::SeasonKeyVo"

    acts_as_list touch_on_update: false, top_of_list: 0

    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships

    scope :latest_order, -> { order(position: :desc) }
    scope :oldest_order, -> { order(position: :asc)  }

    def to_vo
      SeasonKeyVo[key]
    end
  end
end
