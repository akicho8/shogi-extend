# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Grade (swars_grades as Swars::Grade)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | priority   | 優先度   | integer(4)  | NOT NULL    |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

module Swars
  class Grade2 < ApplicationRecord
    include MemoryRecordBind::Base

    acts_as_list top_of_list: 0

    with_options dependent: :destroy do
      has_many :battles
      has_many :memberships, through: :battles
    end

    def name
      key
    end
  end
end
