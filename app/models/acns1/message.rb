# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Message (acns1_messages as Acns1::Message)
#
# |------------+----------+-------------+-------------+-----------------------+-------|
# | name       | desc     | type        | opts        | refs                  | index |
# |------------+----------+-------------+-------------+-----------------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |                       |       |
# | user_id    | User     | integer(8)  |             | => Colosseum::User#id | A     |
# | room_id    | Room     | integer(8)  |             |                       | B     |
# | body       | 内容     | text(65535) |             |                       |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |                       |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |                       |       |
# |------------+----------+-------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_master_xrecord
#--------------------------------------------------------------------------------

module Acns1
  class Message < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :room

    with_options presence: true do
      validates :body
    end

    after_create_commit do
      Acns1::MessageBroadcastJob.perform_later(self)
    end
  end
end
