# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Watch shipテーブル (fanta_watch_ships as Fanta::WatchShip)
#
# |------------+----------+------------+-------------+------+-------|
# | カラム名   | 意味     | タイプ     | 属性        | 参照 | INDEX |
# |------------+----------+------------+-------------+------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |      |       |
# | battle_id  | Battle   | integer(8) | NOT NULL    |      | A     |
# | user_id    | User     | integer(8) | NOT NULL    |      | B     |
# | created_at | 作成日時 | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime   | NOT NULL    |      |       |
# |------------+----------+------------+-------------+------+-------|

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
