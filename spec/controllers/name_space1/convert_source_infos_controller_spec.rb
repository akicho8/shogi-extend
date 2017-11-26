# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (convert_source_infos as ConvertSourceInfo)
#
# |-------------+--------------------+-------------+-------------+------+-------|
# | カラム名    | 意味               | タイプ      | 属性        | 参照 | INDEX |
# |-------------+--------------------+-------------+-------------+------+-------|
# | id          | ID                 | integer(8)  | NOT NULL PK |      |       |
# | unique_key  | ユニークなハッシュ | string(255) | NOT NULL    |      |       |
# | kifu_file   | 棋譜ファイル       | string(255) |             |      |       |
# | kifu_url    | 棋譜URL            | string(255) |             |      |       |
# | kifu_body   | 棋譜内容           | text(65535) |             |      |       |
# | turn_max    | 手数               | integer(4)  |             |      |       |
# | kifu_header | 棋譜ヘッダー       | text(65535) |             |      |       |
# | created_at  | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at  | 更新日時           | datetime    | NOT NULL    |      |       |
# |-------------+--------------------+-------------+-------------+------+-------|

require 'rails_helper'

RSpec.describe NameSpace1::ConvertSourceInfosController, type: :controller do
  it "index" do
    ConvertSourceInfo.create!
    get :index, params: {}
  end

  it "show" do
    @convert_source_info = ConvertSourceInfo.create!
    get :show, params: {id: @convert_source_info.to_param}
  end
end
