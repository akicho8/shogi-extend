# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Lobby message (actb_lobby_messages as Actb::LobbyMessage)
#
# |------------+----------+-------------+-------------+-----------------------+-------|
# | name       | desc     | type        | opts        | refs                  | index |
# |------------+----------+-------------+-------------+-----------------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |                       |       |
# | user_id    | User     | integer(8)  |             | => Colosseum::User#id | A     |
# | body       | 内容     | string(512) |             |                       |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |                       |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |                       |       |
# |------------+----------+-------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_profile
#--------------------------------------------------------------------------------

module Actb
  class LobbyMessage < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User"

    with_options presence: true do
      validates :body
    end

    after_create_commit do
      Actb::LobbyMessageBroadcastJob.perform_later(self)
    end
  end
end
