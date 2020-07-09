# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Grade (swars_grades as Swars::Grade)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      | A!    |
# | priority   | Priority           | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

module Swars
  class Grade < ApplicationRecord
    class << self
      def setup(options = {})
        super

        GradeInfo.each do |e|
          record = find_or_initialize_by(key: e.key)
          record.priority = e.priority
          record.save!
        end
      end
    end

    has_many :users, dependent: :destroy

    default_scope { order(:priority) }

    before_validation do
      self.priority ||= grade_info.priority
    end

    with_options presence: true do
      validates :key
    end

    with_options allow_blank: true do
      validates :key, inclusion: GradeInfo.keys.collect(&:to_s)
    end

    def grade_info
      @grade_info ||= GradeInfo.fetch(key)
    end

    def name
      key
    end
  end
end
