# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (general_battle_records as GeneralBattleRecord)
#
# |--------------------------+--------------------------+-------------+-------------+------+-------|
# | カラム名                 | 意味                     | タイプ      | 属性        | 参照 | INDEX |
# |--------------------------+--------------------------+-------------+-------------+------+-------|
# | id                       | ID                       | integer(8)  | NOT NULL PK |      |       |
# | battle_key               | Battle key               | string(255) | NOT NULL    |      | A!    |
# | battled_at               | Battled at               | datetime    |             |      |       |
# | kifu_body                | 棋譜内容                 | text(65535) | NOT NULL    |      |       |
# | general_battle_state_key | General battle state key | string(255) | NOT NULL    |      | B     |
# | turn_max                 | 手数                     | integer(4)  | NOT NULL    |      |       |
# | meta_info                | 棋譜ヘッダー             | text(65535) | NOT NULL    |      |       |
# | mountain_url             | 将棋山脈URL              | string(255) |             |      |       |
# | created_at               | 作成日時                 | datetime    | NOT NULL    |      |       |
# | updated_at               | 更新日時                 | datetime    | NOT NULL    |      |       |
# |--------------------------+--------------------------+-------------+-------------+------+-------|

class CreateGeneralBattleRecords < ActiveRecord::Migration[5.1]
  def up
    create_table :general_battle_users, force: true do |t|
      t.string :name, null: false, index: {unique: true}, comment: "対局者名"
      t.timestamps null: false
    end

    create_table :general_battle_records, force: true do |t|
      t.string :battle_key, null: false, index: {unique: true}, comment: "対局識別子"
      t.datetime :battled_at, null: true, comment: "対局開始日時"

      # t.integer :battled_at_yyyy, null: false, comment: "対局開始日時"
      # t.integer :battled_at_mm, null: false, comment: "対局開始日時"
      # t.integer :battled_at_dd, null: false, comment: "対局開始日時"

      t.text :kifu_body, null: false, comment: "棋譜の断片"
      t.string :general_battle_state_key, null: false, index: true, comment: "結果詳細"
      t.integer :turn_max, null: false, comment: "手数"
      t.text :meta_info, null: false, comment: "棋譜メタ情報"
      t.string :mountain_url, comment: "将棋山脈の変換後URL"
      t.timestamps null: false
    end

    create_table :general_battle_ships, force: true do |t|
      t.belongs_to :general_battle_record, null: false, comment: "対局"
      t.string :judge_key, null: false, index: true, comment: "勝・敗・引き分け"
      t.string :location_key, null: false, index: true, comment: "▲△"
      t.integer :position, index: true, comment: "手番の順序"
      t.timestamps null: false
    end
    add_index :general_battle_ships, [:general_battle_record_id, :location_key], unique: true, name: :general_battle_ships_gbri_lk
  end
end
