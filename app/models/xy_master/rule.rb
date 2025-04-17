# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Rule (xy_master_rules as XyMaster::Rule)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      |       |
# | position   | 順序     | integer(4)  | NOT NULL    |      | A     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

module XyMaster
  class Rule < ApplicationRecord
    include MemoryRecordBind::Basic
  end
end
