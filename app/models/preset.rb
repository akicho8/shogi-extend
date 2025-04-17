# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Preset (presets as Preset)
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

class Preset < ApplicationRecord
  include MemoryRecordBind::Basic

  with_options dependent: :destroy do
    has_many :swars_battles, class_name: "Swars::Battle"
    # has_many :swars_memberships, through: :swars_battles, source: :membership, class_name: "Swars::Membership"
  end

  with_options dependent: :destroy do
    has_many :free_battles
    # has_many :free_memberships, through: :free_battles
  end
end
