# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Watch ship (fanta_watch_ships as Fanta::WatchShip)
#
# |------------+------------+------------+-------------+------+-------|
# | name       | desc       | type       | opts        | refs | index |
# |------------+------------+------------+-------------+------+-------|
# | id         | ID         | integer(8) | NOT NULL PK |      |       |
# | battle_id  | 部屋ID     | integer(8) | NOT NULL    |      | A     |
# | user_id    | ユーザーID | integer(8) | NOT NULL    |      | B     |
# | created_at | 作成日時   | datetime   | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime   | NOT NULL    |      |       |
# |------------+------------+------------+-------------+------+-------|

module Fanta
  class WatchShip < ApplicationRecord
    belongs_to :battle, counter_cache: true
    belongs_to :user

    # 観戦者が入室/退出した瞬間にチャットルームに反映する
    after_commit do
      ActionCable.server.broadcast(battle.channel_key, watch_ships: ams_sr(battle.reload.watch_ships))
    end
  end
end
