# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room message (emox_room_messages as Emox::RoomMessage)
#
# |------------+----------+-------------+-------------+--------------+-------|
# | name       | desc     | type        | opts        | refs         | index |
# |------------+----------+-------------+-------------+--------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User     | integer(8)  | NOT NULL    | => ::User#id | A     |
# | room_id    | Room     | integer(8)  | NOT NULL    |              | B     |
# | body       | 内容     | string(512) | NOT NULL    |              |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |              |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |              |       |
# |------------+----------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Emox
  class RoomMessage < ApplicationRecord
    include MessageShared

    belongs_to :room

    after_create_commit do
      Emox::RoomMessageBroadcastJob.perform_later(self)
    end
  end
end
