# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局情報テーブル (general/battles as General::Battle)
#
# |--------------------------+-----------------+-------------+-------------+------+-------|
# | カラム名                 | 意味            | タイプ      | 属性        | 参照 | INDEX |
# |--------------------------+-----------------+-------------+-------------+------+-------|
# | id                       | ID              | integer(8)  | NOT NULL PK |      |       |
# | battle_key               | 対局キー        | string(255) | NOT NULL    |      | A!    |
# | battled_at               | 対局日          | datetime    |             |      |       |
# | kifu_body                | 棋譜内容        | text(65535) | NOT NULL    |      |       |
# | battle_state_key | 結果            | string(255) | NOT NULL    |      | B     |
# | turn_max                 | 手数            | integer(4)  | NOT NULL    |      |       |
# | meta_info                | 棋譜ヘッダー    | text(65535) | NOT NULL    |      |       |
# | mountain_url             | 将棋山脈URL     | string(255) |             |      |       |
# | last_accessd_at          | Last accessd at | datetime    | NOT NULL    |      |       |
# | created_at               | 作成日時        | datetime    | NOT NULL    |      |       |
# | updated_at               | 更新日時        | datetime    | NOT NULL    |      |       |
# |--------------------------+-----------------+-------------+-------------+------+-------|

class CreateGeneralBattles < ActiveRecord::Migration[5.1]
  def change
    create_table :general_users, force: true do |t|
      t.string :name, null: false, index: {unique: true}, comment: "対局者名"
      t.timestamps null: false
    end

    create_table :general_battles, force: true do |t|
      t.string   :battle_key,       null: false, index: {unique: true}, comment: "対局識別子"
      t.datetime :battled_at,       null: true,                         comment: "対局開始日時"
      t.text     :kifu_body,        null: false,                        comment: "棋譜の断片"
      t.string   :battle_state_key, null: false, index: true,           comment: "結果詳細"
      t.integer  :turn_max,         null: false,                        comment: "手数"
      t.text     :meta_info,        null: false,                        comment: "棋譜メタ情報"
      t.datetime :last_accessd_at,  null: false,                        comment: "最終参照日時"
      t.timestamps                  null: false
    end

    create_table :general_memberships, force: true do |t|
      t.belongs_to :battle,       null: false,              comment: "対局"
      t.string     :judge_key,    null: false, index: true, comment: "勝・敗・引き分け"
      t.string     :location_key, null: false, index: true, comment: "▲△"
      t.integer    :position, index: true,                  comment: "手番の順序"
      t.timestamps null:false
      t.index [:battle_id, :location_key], unique: true, name: :general_memberships_126b7e47a41d11c2
    end
  end
end
