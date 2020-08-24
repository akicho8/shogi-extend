# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Ox mark (xclock_ox_marks as Xclock::OxMark)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | name       | desc               | type        | opts        | refs | index |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      | A     |
# | position   | 順序               | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

module Xclock
  class OxMark < ApplicationRecord
    include StaticMod
  end
end
