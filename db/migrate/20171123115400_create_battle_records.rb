# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle_records as BattleRecord)
#
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | カラム名           | 意味             | タイプ      | 属性        | 参照             | INDEX |
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | id                 | ID               | integer(8)  | NOT NULL PK |                  |       |
# | battle_key         | Battle key       | string(255) | NOT NULL    |                  | A!    |
# | battled_at         | Battled at       | datetime    | NOT NULL    |                  |       |
# | battle_rule_key    | Battle rule key  | string(255) | NOT NULL    |                  | B     |
# | csa_seq            | Csa seq          | text(65535) | NOT NULL    |                  |       |
# | battle_state_key   | Battle state key | string(255) | NOT NULL    |                  | C     |
# | win_battle_user_id | Win battle user  | integer(8)  |             | => BattleUser#id | D     |
# | turn_max           | 手数             | integer(4)  | NOT NULL    |                  |       |
# | kifu_header        | 棋譜ヘッダー     | text(65535) | NOT NULL    |                  |       |
# | mountain_url       | 将棋山脈URL      | string(255) |             |                  |       |
# | created_at         | 作成日時         | datetime    | NOT NULL    |                  |       |
# | updated_at         | 更新日時         | datetime    | NOT NULL    |                  |       |
# |--------------------+------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】BattleUserモデルで has_many :battle_records されていません
#--------------------------------------------------------------------------------

class CreateBattleRecords < ActiveRecord::Migration[5.1]
  def up
    create_table :battle_users, force: true do |t|
      t.string :uid, null: false, index: {unique: true}, comment: "対局者名"
      t.belongs_to :battle_grade, null: false, comment: "最高段級"
      t.timestamps null: false
    end

    create_table :battle_records, force: true do |t|
      t.string :battle_key, null: false, index: {unique: true}, comment: "対局識別子"
      t.datetime :battled_at, null: false, comment: "対局開始日時"
      t.string :battle_rule_key, null: false, index: true, comment: "ルール"
      t.text :csa_seq, null: false, comment: "棋譜の断片"
      t.string :battle_state_key, null: false, index: true, comment: "結果詳細"
      t.belongs_to :win_battle_user, comment: "勝者(ショートカット用)"

      t.integer :turn_max, null: false, comment: "手数"
      t.text :kifu_header, null: false, comment: "棋譜メタ情報"

      t.string :mountain_url, comment: "将棋山脈の変換後URL"

      t.timestamps null: false
    end

    create_table :battle_ships, force: true do |t|
      t.belongs_to :battle_record, null: false, comment: "対局"
      t.belongs_to :battle_user, null: false, comment: "対局者"
      t.belongs_to :battle_grade, null: false, comment: "対局時の段級"
      t.string :judge_key, null: false, index: true, comment: "勝・敗・引き分け"
      t.integer :position, index: true, comment: "手番の順序"
      t.timestamps null: false
    end

    create_table :battle_grades, force: true do |t|
      t.string :unique_key, null: false, index: {unique: true}
      t.integer :priority, null: false, index: true, comment: "優劣"
      t.timestamps null: false
    end
  end
end
