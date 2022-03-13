# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Rule (swars_rules as Swars::Rule)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

module Swars
  # のちのち対応
  class Rule
  end
  # class Rule < ApplicationRecord
  # include MemoryRecordBind::Base
  #
  # with_options dependent: :destroy do
  #   has_many :battles
  #   has_many :memberships, through: :battles
  # end
  #
  # def rule_info
  #   pure_info
  # end
  #
  # def name
  #   key
  # end
  # end
end
