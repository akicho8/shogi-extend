# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (kifu_convert_infos as KifuConvertInfo)
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
# | created_at    | 作成日時           | datetime | NOT NULL    |      |       |
# | updated_at    | 更新日時           | datetime | NOT NULL    |      |       |
# |---------------+--------------------+----------+-------------+------+-------|

class CreateKifuConvertInfos < ActiveRecord::Migration[5.1]
  def up
    create_table :kifu_convert_infos, force: true do |t|
      t.string :unique_key, null: false
      t.string :kifu_file
      t.string :kifu_url
      t.text :kifu_body
      t.text :converted_ki2
      t.text :converted_kif
      t.timestamps null: false
    end
  end
end
