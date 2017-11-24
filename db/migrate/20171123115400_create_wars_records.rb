# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (wars_records as WarsRecord)
#
# |---------------+--------------------+----------+-------------+------+-------|
# | カラム名      | 意味               | タイプ   | 属性        | 参照 | INDEX |
# |---------------+--------------------+----------+-------------+------+-------|
# | id            | ID                 | integer  | NOT NULL PK |      |       |
# | unique_key    | ユニークなハッシュ | string   | NOT NULL    |      |       |
# | battle_key    | Battle key         | string   | NOT NULL    |      |       |
# | battled_at    | Battled at         | datetime | NOT NULL    |      |       |
# | game_type_key | Game type key      | string   | NOT NULL    |      |       |
# | csa_hands     | Csa hands          | text     | NOT NULL    |      |       |
# | converted_ki2 | 変換後KI2          | text     |             |      |       |
# | converted_kif | 変換後KIF          | text     |             |      |       |
# | converted_csa | 変換後CSA          | text     |             |      |       |
# | turn_max      | 手数               | integer  |             |      |       |
# | kifu_header   | 棋譜ヘッダー       | text     |             |      |       |
# | created_at    | 作成日時           | datetime | NOT NULL    |      |       |
# | updated_at    | 更新日時           | datetime | NOT NULL    |      |       |
# |---------------+--------------------+----------+-------------+------+-------|

class CreateWarsRecords < ActiveRecord::Migration[5.1]
  def up
    create_table :wars_users, force: true do |t|
      t.string :unique_key, null: false
      t.string :user_key, null: false
      t.belongs_to :wars_rank
      t.timestamps null: false
    end

    create_table :wars_records, force: true do |t|
      t.string :unique_key, null: false
      t.string :battle_key, null: false
      t.datetime :battled_at, null: false
      t.string :game_type_key, null: false
      t.text :csa_hands, null: false
      t.string :reason_key, null: false
      t.belongs_to :win_wars_user

      t.text :converted_ki2
      t.text :converted_kif
      t.text :converted_csa
      t.integer :turn_max
      t.text :kifu_header

      t.timestamps null: false
    end

    create_table :wars_ships, force: true do |t|
      t.belongs_to :wars_record
      t.belongs_to :wars_user
      t.belongs_to :wars_rank # そのときの段位
      t.boolean :win_flag, null: false
      t.integer :position
      t.timestamps null: false
    end

    create_table :wars_ranks, force: true do |t|
      t.string :unique_key, null: false
      t.integer :priority, null: false
      t.timestamps null: false
    end
  end
end
