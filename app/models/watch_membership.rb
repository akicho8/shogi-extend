# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Watch membershipテーブル (watch_memberships as WatchMembership)
#
# |--------------+-----------+------------+-------------+----------------+-------|
# | カラム名     | 意味      | タイプ     | 属性        | 参照           | INDEX |
# |--------------+-----------+------------+-------------+----------------+-------|
# | id           | ID        | integer(8) | NOT NULL PK |                |       |
# | chat_room_id | Chat room | integer(8) | NOT NULL    | => ChatRoom#id | A     |
# | chat_user_id | Chat user | integer(8) | NOT NULL    | => ChatUser#id | B     |
# | created_at   | 作成日時  | datetime   | NOT NULL    |                |       |
# | updated_at   | 更新日時  | datetime   | NOT NULL    |                |       |
# |--------------+-----------+------------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・WatchMembership モデルは ChatRoom モデルから has_many :room_chat_messages されています。
# ・WatchMembership モデルは ChatUser モデルから has_many :room_chat_messages されています。
#--------------------------------------------------------------------------------

class WatchMembership < ApplicationRecord
  belongs_to :chat_room, counter_cache: true
  belongs_to :chat_user

  after_commit do
    # 観戦者が入室/退出した瞬間にチャットルームに反映する
    ActionCable.server.broadcast("chat_room_channel_#{chat_room.id}", watch_users: chat_room.watch_users)
  end
end
