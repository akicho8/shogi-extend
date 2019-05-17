# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | name              | desc               | type        | opts        | refs                              | index |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)  | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255) | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255) |             |                                   |       |
# | kifu_body         | 棋譜               | text(65535) | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)  | NOT NULL    |                                   | D     |
# | meta_info         | 棋譜ヘッダー       | text(65535) | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime    | NOT NULL    |                                   | C     |
# | created_at        | 作成日時           | datetime    | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime    | NOT NULL    |                                   |       |
# | colosseum_user_id | 所有者ID           | integer(8)  |             | :owner_user => Colosseum::User#id | B     |
# | title             | タイトル           | string(255) |             |                                   |       |
# | description       | 備考               | text(65535) | NOT NULL    |                                   |       |
# | start_turn        | 開始手数           | integer(4)  |             |                                   |       |
# | critical_turn     | Critical turn      | integer(4)  |             |                                   |       |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class AddStartTurnToFreeBattles < ActiveRecord::Migration[5.2]
  def change
    [:swars_battles, :free_battles, :general_battles].each do |table|
      change_table table do |t|
        t.integer :start_turn, null: false, index: true
      end
    end

    # MySQL では null: false にすると既存レコードには 0 が入る
    # [Swars::Battle, General::Battle, FreeBattle].each do |model|
    #   model.find_each(&:save!)
    # end
  end
end
