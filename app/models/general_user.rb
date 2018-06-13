# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局者テーブル (general_users as GeneralUser)
#
# |------------+----------+-------------+-------------+------+-------|
# | カラム名   | 意味     | タイプ      | 属性        | 参照 | INDEX |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | name       | Name     | string(255) | NOT NULL    |      | A!    |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

class GeneralUser < ApplicationRecord
  with_options presence: true do
    validates :name
  end

  with_options allow_blank: true do
    validates :name, uniqueness: true
  end

  def to_param
    name
  end
end
