# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room membership (actb_room_memberships as Actb::RoomMembership)
#
# |------------+----------+------------+-------------+-----------------------+-------|
# | name       | desc     | type       | opts        | refs                  | index |
# |------------+----------+------------+-------------+-----------------------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |                       |       |
# | room_id    | Room     | integer(8) | NOT NULL    |                       | A! B  |
# | user_id    | User     | integer(8) | NOT NULL    | => Colosseum::User#id | A! C  |
# | position   | 順序     | integer(4) | NOT NULL    |                       | D     |
# | created_at | 作成日時 | datetime   | NOT NULL    |                       |       |
# | updated_at | 更新日時 | datetime   | NOT NULL    |                       |       |
# |------------+----------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_master_xrecord
#--------------------------------------------------------------------------------

module Actb
  class RoomMembership < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :room

    acts_as_list top_of_list: 0, scope: :room
  end
end
