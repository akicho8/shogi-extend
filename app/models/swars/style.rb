# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Style (swars_styles as Swars::Style)
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
  class Style < ApplicationRecord
    include MemoryRecordBind::Basic

    # delegate :short_name, :long_name, :real_life_time, to: :pure_info

    with_options dependent: :destroy do
      has_many :memberships
      has_many :battles, through: :memberships
    end
  end
end
