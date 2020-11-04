# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Season (emox_seasons as Emox::Season)
#
# |------------+------------+-------------+-------------+------+-------|
# | name       | desc       | type        | opts        | refs | index |
# |------------+------------+-------------+-------------+------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |      |       |
# | name       | Name       | string(255) | NOT NULL    |      |       |
# | generation | Generation | integer(4)  | NOT NULL    |      | A     |
# | begin_at   | Begin at   | datetime    | NOT NULL    |      | B     |
# | end_at     | End at     | datetime    | NOT NULL    |      | C     |
# | created_at | 作成日時   | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |      |       |
# |------------+------------+-------------+-------------+------+-------|

module Emox
  # rails r "Emox::Season.create!; tp Emox::Season"
  class Season < ApplicationRecord
    has_many :xrecords, class_name: "Emox::SeasonXrecord", dependent: :destroy

    scope :newest_order, -> { order(generation: :desc) }
    scope :oldest_order, -> { order(generation: :asc)  }

    class << self
      def setup(options = {})
        unless exists?
          create!
        end
      end

      def newest
        newest_order.first || create!
      end
    end

    before_validation do
      self.generation ||= next_generation
      self.name       ||= "シーズン#{generation}"
      self.begin_at   ||= Time.current.beginning_of_month
      self.end_at     ||= Time.current.beginning_of_month.next_month(3)
    end

    private

    def next_generation
      if record = self.class.newest_order.first
        record.generation.next
      else
        Season.count.next
      end
    end
  end
end
