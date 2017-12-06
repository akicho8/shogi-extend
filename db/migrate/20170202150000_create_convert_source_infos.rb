# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (convert_source_infos as ConvertSourceInfo)
#
# |-------------+--------------------+-------------+-------------+------+-------|
# | カラム名    | 意味               | タイプ      | 属性        | 参照 | INDEX |
# |-------------+--------------------+-------------+-------------+------+-------|
# | id          | ID                 | integer(8)  | NOT NULL PK |      |       |
# | unique_key  | ユニークなハッシュ | string(255) | NOT NULL    |      | A     |
# | kifu_file   | 棋譜ファイル       | string(255) |             |      |       |
# | kifu_url    | 棋譜URL            | string(255) |             |      |       |
# | kifu_body   | 棋譜内容           | text(65535) |             |      |       |
# | turn_max    | 手数               | integer(4)  |             |      |       |
# | kifu_header | 棋譜ヘッダー       | text(65535) |             |      |       |
# | created_at  | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at  | 更新日時           | datetime    | NOT NULL    |      |       |
# |-------------+--------------------+-------------+-------------+------+-------|

class CreateConvertSourceInfos < ActiveRecord::Migration[5.1]
  def up
    create_table :convert_source_infos, force: true do |t|
      t.string :unique_key, null: false, index: true
      t.string :kifu_file
      t.string :kifu_url
      t.text :kifu_body
      t.integer :turn_max
      t.text :kifu_header
      t.timestamps null: false
    end

    create_table :converted_infos, force: true do |t|
      t.belongs_to :convertable, polymorphic: true
      t.text :converted_body, null: false
      t.string :converted_format, null: false, index: true
      t.timestamps null: false
    end
  end
end
