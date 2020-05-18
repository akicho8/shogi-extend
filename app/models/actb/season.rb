# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Season (actb_seasons as Actb::Season)
#
# |------------+------------+-------------+-------------+------+-------|
# | name       | desc       | type        | opts        | refs | index |
# |------------+------------+-------------+-------------+------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |      |       |
# | name       | Name       | string(255) | NOT NULL    |      |       |
# | generation | Generation | integer(4)  | NOT NULL    |      | A     |
# | created_at | 作成日時   | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |      |       |
# |------------+------------+-------------+-------------+------+-------|

module Actb
  class Season < ApplicationRecord
    attribute :begin_at
    attribute :end_at

    has_many :profiles, class_name: "Actb::Profile", dependent: :destroy

    scope :newest_order, -> { order(generation: :desc) }
    scope :oldest_order, -> { order(generation: :asc)  }

    class << self
      def setup(options = {})
        unless Season.exists?
          Season.create!
        end
      end

      def newest
        newest_order.first || create!
      end
    end

    before_validation do
      self.generation ||= Season.count.next
      self.name = "シーズン#{generation}"
      self.begin_at ||= Time.current.beginning_of_month
      self.end_at   ||= Time.current.beginning_of_month.next_month(3)
    end
  end
end
