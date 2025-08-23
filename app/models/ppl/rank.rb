# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Rank (ppl_ranks as Ppl::Rank)
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

module Ppl
  class Rank < ApplicationRecord
    include MemoryRecordBind::Basic

    has_many :users, class_name: "Ppl::User", dependent: :destroy
  end
end
