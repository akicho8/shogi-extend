# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room chat messageテーブル (room_chat_messages as RoomChatMessage)
#
# |--------------+-----------+-------------+-------------+----------------+-------|
# | カラム名     | 意味      | タイプ      | 属性        | 参照           | INDEX |
# |--------------+-----------+-------------+-------------+----------------+-------|
# | id           | ID        | integer(8)  | NOT NULL PK |                |       |
# | chat_room_id | Chat room | integer(8)  | NOT NULL    | => ChatRoom#id | A     |
# | chat_user_id | Chat user | integer(8)  | NOT NULL    | => ChatUser#id | B     |
# | message      | Message   | text(65535) | NOT NULL    |                |       |
# | created_at   | 作成日時  | datetime    | NOT NULL    |                |       |
# | updated_at   | 更新日時  | datetime    | NOT NULL    |                |       |
# |--------------+-----------+-------------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・RoomChatMessage モデルは ChatRoom モデルから has_many :room_chat_messages されています。
# ・RoomChatMessage モデルは ChatUser モデルから has_many :room_chat_messages されています。
#--------------------------------------------------------------------------------

class RoomChatMessage < ApplicationRecord
  belongs_to :chat_user
  belongs_to :chat_room

  scope :latest_list, -> { order(:created_at).limit(10) } # チャットルームに表示する最新N件

  # 非同期にするため
  after_create_commit do
    RoomChatMessageBroadcastJob.perform_later(self)
  end

  def js_attributes
    JSON.load(to_json(include: [{:chat_user => {methods: [:avatar_url]}}, :chat_room]))
  end
end
