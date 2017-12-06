# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle_records as BattleRecord)
#
# |--------------------+--------------------+-------------+-------------+------------------+-------|
# | カラム名           | 意味               | タイプ      | 属性        | 参照             | INDEX |
# |--------------------+--------------------+-------------+-------------+------------------+-------|
# | id                 | ID                 | integer(8)  | NOT NULL PK |                  |       |
# | unique_key         | ユニークなハッシュ | string(255) | NOT NULL    |                  | A     |
# | battle_key         | Battle key         | string(255) | NOT NULL    |                  | B     |
# | battled_at         | Battled at         | datetime    | NOT NULL    |                  |       |
# | battle_group_key   | Battle group key   | string(255) | NOT NULL    |                  | C     |
# | csa_seq            | Csa seq            | text(65535) | NOT NULL    |                  |       |
# | battle_state_key  | Battle result key  | string(255) | NOT NULL    |                  | D     |
# | win_battle_user_id | Win battle user    | integer(8)  |             | => BattleUser#id | E     |
# | turn_max           | 手数               | integer(4)  |             |                  |       |
# | kifu_header        | 棋譜ヘッダー       | text(65535) |             |                  |       |
# | sanmyaku_view_url  | Sanmyaku view url  | string(255) |             |                  |       |
# | created_at         | 作成日時           | datetime    | NOT NULL    |                  |       |
# | updated_at         | 更新日時           | datetime    | NOT NULL    |                  |       |
# |--------------------+--------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】BattleUserモデルで has_many :battle_records されていません
#--------------------------------------------------------------------------------

class CreateBattleRecords < ActiveRecord::Migration[5.1]
  def up
    create_table :battle_users, force: true do |t|
      t.string :unique_key, null: false, index: true
      t.string :battle_user_key, null: false, index: true
      t.belongs_to :battle_rank
      t.timestamps null: false
    end

    create_table :battle_records, force: true do |t|
      t.string :battle_key, null: false, index: true
      t.datetime :battled_at, null: false
      t.string :battle_group_key, null: false, index: true
      t.text :csa_seq, null: false
      t.string :battle_state_key, null: false, index: true
      t.belongs_to :win_battle_user

      t.integer :turn_max
      t.text :kifu_header

      t.string :sanmyaku_view_url

      t.timestamps null: false
    end

    create_table :battle_ships, force: true do |t|
      t.belongs_to :battle_record
      t.belongs_to :battle_user
      t.belongs_to :battle_rank # そのときの段位
      t.string :win_lose_key, null: false, index: true
      t.integer :position, index: true
      t.timestamps null: false
    end

    create_table :battle_ranks, force: true do |t|
      t.string :unique_key, null: false, index: true
      t.integer :priority, null: false, index: true
      t.timestamps null: false
    end
  end
end
