# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle2_records as Battle2Record)
#
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | カラム名           | 意味             | タイプ      | 属性        | 参照             | INDEX |
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | id                 | ID               | integer(8)  | NOT NULL PK |                  |       |
# | battle_key         | Battle2 key       | string(255) | NOT NULL    |                  | A!    |
# | battled_at         | Battle2d at       | datetime    | NOT NULL    |                  |       |
# | battle2_rule_key    | Battle2 rule key  | string(255) | NOT NULL    |                  | B     |
# | csa_seq            | Csa seq          | text(65535) | NOT NULL    |                  |       |
# | battle2_state_key   | Battle2 state key | string(255) | NOT NULL    |                  | C     |
# | win_battle2_user_id | Win battle user  | integer(8)  |             | => Battle2User#id | D     |
# | turn_max           | 手数             | integer(4)  | NOT NULL    |                  |       |
# | kifu_header        | 棋譜ヘッダー     | text(65535) | NOT NULL    |                  |       |
# | mountain_url       | 将棋山脈URL      | string(255) |             |                  |       |
# | created_at         | 作成日時         | datetime    | NOT NULL    |                  |       |
# | updated_at         | 更新日時         | datetime    | NOT NULL    |                  |       |
# |--------------------+------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】Battle2Userモデルで has_many :battle2_records されていません
#--------------------------------------------------------------------------------

class CreateBattle2Records < ActiveRecord::Migration[5.1]
  def up
    create_table :battle2_users, force: true do |t|
      t.string :uid, null: false, index: {unique: true}, comment: "対局者名"
      t.belongs_to :battle2_grade, null: false, comment: "最高段級"
      t.datetime :last_reception_at, null: true, comment: "受容日時"
      t.integer :battle2_user_receptions_count, default: 0
      t.timestamps null: false
    end

    create_table :battle2_records, force: true do |t|
      t.string :battle_key, null: false, index: {unique: true}, comment: "対局識別子"
      t.datetime :battled_at, null: false, comment: "対局開始日時"
      t.text :kifu_body, null: false, comment: "棋譜の断片"
      t.string :battle2_state_key, null: false, index: true, comment: "結果詳細"
      t.belongs_to :win_battle2_user, comment: "勝者(ショートカット用)"

      t.integer :turn_max, null: false, comment: "手数"
      t.text :kifu_header, null: false, comment: "棋譜メタ情報"

      t.string :mountain_url, comment: "将棋山脈の変換後URL"

      t.timestamps null: false
    end

    create_table :battle2_ships, force: true do |t|
      t.belongs_to :battle2_record, null: false, comment: "対局"
      t.belongs_to :battle2_user, null: false, comment: "対局者"
      t.belongs_to :battle2_grade, null: false, comment: "対局時の段級"
      t.string :judge_key, null: false, index: true, comment: "勝・敗・引き分け"
      t.string :location_key, null: false, index: true, comment: "▲△"
      t.integer :position, index: true, comment: "手番の順序"
      t.timestamps null: false
    end
    add_index :battle2_ships, [:battle2_record_id, :location_key], unique: true
    add_index :battle2_ships, [:battle2_record_id, :battle2_user_id], unique: true

    create_table :battle2_grades, force: true do |t|
      t.string :unique_key, null: false, index: {unique: true}
      t.integer :priority, null: false, index: true, comment: "優劣"
      t.timestamps null: false
    end

    create_table :battle2_user_receptions, force: true do |t|
      t.belongs_to :battle2_user, null: false, comment: "プレイヤー"
      t.timestamps null: false
    end
  end
end
