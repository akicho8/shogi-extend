# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (battle_records as BattleRecord)
#
# |---------------+--------------------+----------+-------------+------+-------|
# | カラム名      | 意味               | タイプ   | 属性        | 参照 | INDEX |
# |---------------+--------------------+----------+-------------+------+-------|
# | id            | ID                 | integer  | NOT NULL PK |      |       |
# | unique_key    | ユニークなハッシュ | string   | NOT NULL    |      |       |
# | kifu_file     | 棋譜ファイル       | string   |             |      |       |
# | kifu_url      | 棋譜URL            | string   |             |      |       |
# | kifu_body     | 棋譜内容           | text     |             |      |       |
# | converted_ki2 | 変換後KI2          | text     |             |      |       |
# | converted_kif | 変換後KIF          | text     |             |      |       |
# | turn_max      | 手数               | integer  |             |      |       |
# | kifu_header   | 棋譜ヘッダー       | text     |             |      |       |
# | created_at    | 作成日時           | datetime | NOT NULL    |      |       |
# | updated_at    | 更新日時           | datetime | NOT NULL    |      |       |
# |---------------+--------------------+----------+-------------+------+-------|

class CreateBattleRecords < ActiveRecord::Migration[5.1]
  def up
    create_table :battle_users, force: true do |t|
      t.string :unique_key, null: false
      t.string :user_key, null: false
      t.string :user_rank
      t.timestamps null: false
    end

    create_table :battle_records, force: true do |t|
      t.string :unique_key, null: false
      t.string :battle_key, null: false
      t.string :game_type_key, null: false
      t.text :csa_hands, null: false
      t.timestamps null: false
    end

    create_table :battle_ships, force: true do |t|
      t.belongs_to :battle_user
      t.belongs_to :battle_record
      t.integer :position
      t.timestamps null: false
    end
  end
end
