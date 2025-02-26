# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xmode2 (swars_xmode2s as Swars::Xmode2)
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

module Swars
  class Xmode2 < ApplicationRecord
    include MemoryRecordBind::Basic

    with_options dependent: :destroy do
      has_many :battles
      has_many :memberships, through: :battles
    end

    # def name
    #   key
    # end
  end
end
