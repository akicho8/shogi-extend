# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Lobby chat messageテーブル (lobby_chat_messages as LobbyChatMessage)
#
# |--------------+-----------+-------------+-------------+----------------+-------|
# | カラム名     | 意味      | タイプ      | 属性        | 参照           | INDEX |
# |--------------+-----------+-------------+-------------+----------------+-------|
# | id           | ID        | integer(8)  | NOT NULL PK |                |       |
# | chat_user_id | Chat user | integer(8)  | NOT NULL    | => ChatUser#id | A     |
# | message      | Message   | text(65535) | NOT NULL    |                |       |
# | created_at   | 作成日時  | datetime    | NOT NULL    |                |       |
# | updated_at   | 更新日時  | datetime    | NOT NULL    |                |       |
# |--------------+-----------+-------------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・LobbyChatMessage モデルは ChatUser モデルから has_many :room_chat_messages されています。
#--------------------------------------------------------------------------------

class LobbyChatMessage < ApplicationRecord
  belongs_to :chat_user

  # # 非同期にするため
  # after_create_commit do
  #   RoomChatMessageBroadcastJob.perform_later(self)
  # end

  def js_attributes
    JSON.load(to_json(include: [:chat_user]))
  end
end
