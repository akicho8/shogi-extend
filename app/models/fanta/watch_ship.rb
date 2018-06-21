# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Watch membershipテーブル (watch_ships as WatchShip)
#
# |----------------+-------------+------------+-------------+------------------+-------|
# | カラム名       | 意味        | タイプ     | 属性        | 参照             | INDEX |
# |----------------+-------------+------------+-------------+------------------+-------|
# | id             | ID          | integer(8) | NOT NULL PK |                  |       |
# | battle_id | Battle room | integer(8) | NOT NULL    | => Battle#id | A     |
# | user_id        | User        | integer(8) | NOT NULL    | => User#id       | B     |
# | created_at     | 作成日時    | datetime   | NOT NULL    |                  |       |
# | updated_at     | 更新日時    | datetime   | NOT NULL    |                  |       |
# |----------------+-------------+------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・WatchShip モデルは Battle モデルから has_many :memberships されています。
# ・WatchShip モデルは User モデルから has_many :chat_messages されています。
#--------------------------------------------------------------------------------

module Fanta
  class WatchShip < ApplicationRecord
    belongs_to :battle, counter_cache: true
    belongs_to :user

    after_commit do
      # 観戦者が入室/退出した瞬間にチャットルームに反映する
      ActionCable.server.broadcast("battle_channel_#{battle.id}", watch_users: battle.watch_users)
    end
  end
end
