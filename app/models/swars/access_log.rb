# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Access log (swars_access_logs as Swars::AccessLog)
#
# |------------+----------+------------+-------------+------+-------|
# | name       | desc     | type       | opts        | refs | index |
# |------------+----------+------------+-------------+------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |      |       |
# | battle_id  | Battle   | integer(8) | NOT NULL    |      | A     |
# | created_at | 作成日時 | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime   | NOT NULL    |      |       |
# |------------+----------+------------+-------------+------+-------|

module Swars
  class AccessLog < ApplicationRecord
    belongs_to :battle, counter_cache: true, touch: :last_accessd_at
  end
end
