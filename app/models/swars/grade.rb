# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Gradeテーブル (swars_grades as Swars::Grade)
#
# |------------+----------+-------------+-------------+------+-------|
# | カラム名   | 意味     | タイプ      | 属性        | 参照 | INDEX |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | Key      | string(255) | NOT NULL    |      | A!    |
# | priority   | Priority | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

module Swars
  class Grade < ApplicationRecord
    has_many :users, dependent: :destroy

    default_scope { order(:priority) }

    with_options presence: true do
      validates :key
    end

    with_options allow_blank: true do
      validates :key, inclusion: GradeInfo.collect(&:name)
    end

    def grade_info
      GradeInfo.fetch(key)
    end

    delegate :name, to: :grade_info
  end
end
