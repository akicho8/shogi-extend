# -*- coding: utf-8 -*-
# == Schema Information ==
#
# User (general_users as General::User)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | name       | Name     | string(255) | NOT NULL    |      | A!    |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

module General
  class User < ApplicationRecord
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
end
