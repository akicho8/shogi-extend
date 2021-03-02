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
    include MemoryRecordBind::Base

    with_options dependent: :destroy do
      has_many :users
      has_many :memberships
      has_many :battles, through: :memberships
    end

    default_scope { order(:priority) }

    before_validation do
      self.priority ||= grade_info.priority
    end

    def grade_info
      pure_info
    end

    def name
      key
    end
  end
end
