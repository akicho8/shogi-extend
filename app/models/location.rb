# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Location (locations as Location)
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

class Location < ApplicationRecord
  include MemoryRecordBind::Basic

  delegate :call_name, to: :pure_info

  with_options dependent: :destroy do
    has_many :swars_memberships, class_name: "Swars::Membership"
    has_many :swars_battles, through: :swars_memberships, source: :battle, class_name: "Swars::Battle"
  end

  # class << self
  #   def black
  #     @black ||= self[:black]
  #   end
  #
  #   def white
  #     @white ||= self[:white]
  #   end
  # end
end
