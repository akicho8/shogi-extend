# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Watch membershipテーブル (watch_memberships as Fanta::WatchMembership)
#
# |----------------+-------------+------------+-------------+------------------+-------|
# | カラム名       | 意味        | タイプ     | 属性        | 参照             | INDEX |
# |----------------+-------------+------------+-------------+------------------+-------|
# | id             | ID          | integer(8) | NOT NULL PK |                  |       |
# | battle_room_id | Battle room | integer(8) | NOT NULL    | => Fanta::BattleRoom#id | A     |
# | user_id        | Fanta::User        | integer(8) | NOT NULL    | => Fanta::User#id       | B     |
# | created_at     | 作成日時    | datetime   | NOT NULL    |                  |       |
# | updated_at     | 更新日時    | datetime   | NOT NULL    |                  |       |
# |----------------+-------------+------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・Fanta::WatchMembership モデルは Fanta::BattleRoom モデルから has_many :memberships されています。
# ・Fanta::WatchMembership モデルは Fanta::User モデルから has_many :chat_messages されています。
#--------------------------------------------------------------------------------

class Fanta::WatchMembership < ApplicationRecord
  belongs_to :battle_room, counter_cache: true
  belongs_to :user

  after_commit do
    # 観戦者が入室/退出した瞬間にチャットルームに反映する
    ActionCable.server.broadcast("battle_room_channel_#{battle_room.id}", watch_users: battle_room.watch_users)
  end
end
