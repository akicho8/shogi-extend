# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Sequence (wkbk_sequences as Wkbk::Sequence)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | position   | 順序     | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

module Wkbk
  class Sequence < ApplicationRecord
    include MemoryRecordBind::Basic

    has_many :books, dependent: :restrict_with_exception
  end
end
