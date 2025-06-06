# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Judge (judges as Judge)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | position   | 順序     | integer(4)  |             |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

class Judge < ApplicationRecord
  include MemoryRecordBind::Basic

  with_options dependent: :destroy do
    has_many :swars_memberships, class_name: "Swars::Membership"
    # has_many :swars_battles, through: :swars_memberships
  end
end
