# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room message (actf_room_messages as Actf::RoomMessage)
#
# |------------+----------+-------------+-------------+-----------------------+-------|
# | name       | desc     | type        | opts        | refs                  | index |
# |------------+----------+-------------+-------------+-----------------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |                       |       |
# | user_id    | User     | integer(8)  |             | => Colosseum::User#id | A     |
# | room_id    | Room     | integer(8)  |             |                       | B     |
# | body       | 内容     | string(512) |             |                       |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |                       |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |                       |       |
# |------------+----------+-------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :actf_memberships
#--------------------------------------------------------------------------------

module Actf
  class RoomMessage < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :room

    with_options presence: true do
      validates :body
    end

    after_create_commit do
      Actf::RoomMessageBroadcastJob.perform_later(self)
    end
  end
end
