# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Watch membershipテーブル (watch_memberships as WatchMembership)
#
# |--------------+-----------+------------+-------------+----------------+-------|
# | カラム名     | 意味      | タイプ     | 属性        | 参照           | INDEX |
# |--------------+-----------+------------+-------------+----------------+-------|
# | id           | ID        | integer(8) | NOT NULL PK |                |       |
# | battle_room_id | Chat room | integer(8) | NOT NULL    | => BattleRoom#id | A     |
# | user_id | Chat user | integer(8) | NOT NULL    | => User#id | B     |
# | created_at   | 作成日時  | datetime   | NOT NULL    |                |       |
# | updated_at   | 更新日時  | datetime   | NOT NULL    |                |       |
# |--------------+-----------+------------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・WatchMembership モデルは BattleRoom モデルから has_many :room_chat_messages されています。
# ・WatchMembership モデルは User モデルから has_many :room_chat_messages されています。
#--------------------------------------------------------------------------------

class WatchMembership < ApplicationRecord
  belongs_to :battle_room, counter_cache: true
  belongs_to :user

  after_commit do
    # 観戦者が入室/退出した瞬間にチャットルームに反映する
    ActionCable.server.broadcast("battle_room_channel_#{battle_room.id}", watch_users: battle_room.watch_users)
  end
end
