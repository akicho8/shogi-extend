# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room membership (wbook_room_memberships as Wbook::RoomMembership)
#
# |------------+----------+------------+-------------+--------------+-------|
# | name       | desc     | type       | opts        | refs         | index |
# |------------+----------+------------+-------------+--------------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |              |       |
# | room_id    | Room     | integer(8) | NOT NULL    |              | A! B  |
# | user_id    | User     | integer(8) | NOT NULL    | => ::User#id | A! C  |
# | position   | 順序     | integer(4) | NOT NULL    |              | D     |
# | created_at | 作成日時 | datetime   | NOT NULL    |              |       |
# | updated_at | 更新日時 | datetime   | NOT NULL    |              |       |
# |------------+----------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Wbook
  class RoomMembership < ApplicationRecord
    belongs_to :user, class_name: "::User"
    belongs_to :room

    acts_as_list top_of_list: 0, scope: :room
  end
end
