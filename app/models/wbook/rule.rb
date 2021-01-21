# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Rule (wbook_rules as Wbook::Rule)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      |       |
# | position   | 順序               | integer(4)  | NOT NULL    |      | A     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

# matching_user_ids
# matching_users
# matching_users_include?(user)
# matching_users_add(user)
# matching_users_delete(user)

module Wbook
  class Rule < ApplicationRecord
    include MemoryRecordBind

    with_options dependent: :destroy do
      has_many :settings
      has_many :rooms
      has_many :battles
    end
  end
end
