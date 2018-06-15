# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (free_battles as FreeBattle)
#
# |--------------+--------------------+-------------+-------------+------+-------|
# | カラム名     | 意味               | タイプ      | 属性        | 参照 | INDEX |
# |--------------+--------------------+-------------+-------------+------+-------|
# | id           | ID                 | integer(8)  | NOT NULL PK |      |       |
# | unique_key   | ユニークなハッシュ | string(255) | NOT NULL    |      | A!    |
# | kifu_file    | 棋譜ファイル       | string(255) |             |      |       |
# | kifu_url     | 棋譜URL            | string(255) |             |      |       |
# | kifu_body    | 棋譜内容           | text(65535) | NOT NULL    |      |       |
# | turn_max     | 手数               | integer(4)  | NOT NULL    |      |       |
# | meta_info    | 棋譜ヘッダー       | text(65535) | NOT NULL    |      |       |
# | mountain_url | 将棋山脈URL        | string(255) |             |      |       |
# | battled_at   | Battled at         | datetime    | NOT NULL    |      |       |
# | created_at   | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at   | 更新日時           | datetime    | NOT NULL    |      |       |
# |--------------+--------------------+-------------+-------------+------+-------|

class CreateFreeBattles < ActiveRecord::Migration[5.1]
  def up
    create_table :free_battles, force: true do |t|
      t.string :unique_key, null: false, index: {unique: true}, charset: 'utf8', collation: 'utf8_bin', comment: "URL識別子"
      t.string :kifu_url, comment: "入力した棋譜URL"
      t.text :kifu_body, null: false, comment: "棋譜本文"
      t.integer :turn_max, null: false, comment: "手数"
      t.text :meta_info, null: false, comment: "棋譜メタ情報"
      t.string :mountain_url, comment: "将棋山脈の変換後URL"
      t.datetime :battled_at, null: false, comment: "対局開始日時"
      t.timestamps null: false
    end

    create_table :converted_infos, force: true do |t|
      t.belongs_to :convertable, polymorphic: true, null: false, comment: "親"
      t.text :text_body, null: false, comment: "棋譜内容"
      t.string :text_format, null: false, index: true, comment: "棋譜形式"
      t.timestamps null: false
    end
  end
end
