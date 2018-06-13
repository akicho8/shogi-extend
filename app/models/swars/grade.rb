# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Swars battle gradeテーブル (grades as Swars::Grade)
#
# |------------+------------+-------------+-------------+------+-------|
# | カラム名   | 意味       | タイプ      | 属性        | 参照 | INDEX |
# |------------+------------+-------------+-------------+------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |      |       |
# | unique_key | Unique key | string(255) | NOT NULL    |      | A!    |
# | priority   | Priority   | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時   | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |      |       |
# |------------+------------+-------------+-------------+------+-------|

class Swars::Grade < ApplicationRecord
  has_many :users, dependent: :destroy

  default_scope { order(:priority) }

  with_options presence: true do
    validates :unique_key
  end

  with_options allow_blank: true do
    validates :unique_key, inclusion: Swars::GradeInfo.collect(&:name)
  end

  def grade_info
    Swars::GradeInfo.fetch(unique_key)
  end

  delegate :name, to: :grade_info
end
