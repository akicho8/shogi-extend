# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Chronicle (colosseum_chronicles as Colosseum::Chronicle)
#
# |------------+-----------+-------------+-------------+------+-------|
# | name       | desc      | type        | opts        | refs | index |
# |------------+-----------+-------------+-------------+------+-------|
# | id         | ID        | integer(8)  | NOT NULL PK |      |       |
# | user_id    | User      | integer(8)  | NOT NULL    |      | A     |
# | judge_key  | Judge key | string(255) | NOT NULL    |      | B     |
# | created_at | 作成日時  | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時  | datetime    | NOT NULL    |      |       |
# |------------+-----------+-------------+-------------+------+-------|

module Colosseum
  class Chronicle < ApplicationRecord
    belongs_to :user

    scope :judge_eq, -> e { where(judge_key: JudgeInfo.fetch(e).key) }
  end
end
