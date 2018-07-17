# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Chat message (colosseum_chat_messages as Colosseum::ChatMessage)
#
# |-------------+-------------+-------------+-------------+------+-------|
# | name        | desc        | type        | opts        | refs | index |
# |-------------+-------------+-------------+-------------+------+-------|
# | id          | ID          | integer(8)  | NOT NULL PK |      |       |
# | battle_id   | 部屋ID      | integer(8)  | NOT NULL    |      | A     |
# | user_id     | ユーザーID  | integer(8)  | NOT NULL    |      | B     |
# | message     | 発言        | text(65535) | NOT NULL    |      |       |
# | msg_options | Msg options | text(65535) | NOT NULL    |      |       |
# | created_at  | 作成日時    | datetime    | NOT NULL    |      |       |
# | updated_at  | 更新日時    | datetime    | NOT NULL    |      |       |
# |-------------+-------------+-------------+-------------+------+-------|

module Colosseum
  class ChatMessage < ApplicationRecord
    belongs_to :user
    belongs_to :battle

    serialize :msg_options

    scope :latest_list, -> { order(:created_at) } # チャットルームに表示する最新N件

    before_validation on: :create do
      self.msg_options ||= {}
    end
  end
end
