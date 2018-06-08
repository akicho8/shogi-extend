# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room chat messageテーブル (room_chat_messages as RoomChatMessage)
#
# |--------------+-----------+-------------+-------------+----------------+-------|
# | カラム名     | 意味      | タイプ      | 属性        | 参照           | INDEX |
# |--------------+-----------+-------------+-------------+----------------+-------|
# | id           | ID        | integer(8)  | NOT NULL PK |                |       |
# | battle_room_id | Chat room | integer(8)  | NOT NULL    | => BattleRoom#id | A     |
# | user_id | Chat user | integer(8)  | NOT NULL    | => User#id | B     |
# | message      | Message   | text(65535) | NOT NULL    |                |       |
# | created_at   | 作成日時  | datetime    | NOT NULL    |                |       |
# | updated_at   | 更新日時  | datetime    | NOT NULL    |                |       |
# |--------------+-----------+-------------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・RoomChatMessage モデルは BattleRoom モデルから has_many :room_chat_messages されています。
# ・RoomChatMessage モデルは User モデルから has_many :room_chat_messages されています。
#--------------------------------------------------------------------------------

class RoomChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :battle_room

  scope :latest_list, -> { order(:created_at) } # チャットルームに表示する最新N件

  # 非同期にするため
  # after_create_commit do
  #   RoomChatMessageBroadcastJob.perform_later(self)
  # end
end
