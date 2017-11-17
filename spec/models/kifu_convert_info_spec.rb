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
# | turn_max      | 手数               | integer  |             |      |       |
# | kifu_header   | 棋譜ヘッダー       | text     |             |      |       |
# | created_at    | 作成日時           | datetime | NOT NULL    |      |       |
# | updated_at    | 更新日時           | datetime | NOT NULL    |      |       |
# |---------------+--------------------+----------+-------------+------+-------|

require 'rails_helper'

RSpec.describe KifuConvertInfo, type: :model do
  it do
    KifuConvertInfo.create!(kifu_body: "▲７六歩")
  end
end
