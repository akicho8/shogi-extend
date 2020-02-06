# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |-------------------+------------------+--------------+-------------+------+-------|
# | name              | desc             | type         | opts        | refs | index |
# |-------------------+------------------+--------------+-------------+------+-------|
# | id                | ID               | integer(8)   | NOT NULL PK |      |       |
# | key               | 対局ユニークキー | string(255)  | NOT NULL    |      | A!    |
# | battled_at        | 対局日時         | datetime     | NOT NULL    |      | E     |
# | rule_key          | ルール           | string(255)  | NOT NULL    |      | B     |
# | csa_seq           | 棋譜             | text(65535)  | NOT NULL    |      |       |
# | final_key         | 結末             | string(255)  | NOT NULL    |      | C     |
# | win_user_id       | 勝者             | integer(8)   |             |      | D     |
# | turn_max          | 手数             | integer(4)   | NOT NULL    |      | F     |
# | meta_info         | メタ情報         | text(65535)  | NOT NULL    |      |       |
# | last_accessd_at   | 最終アクセス日時 | datetime     | NOT NULL    |      |       |
# | access_logs_count | アクセス数       | integer(4)   | DEFAULT(0)  |      |       |
# | created_at        | 作成日時         | datetime     | NOT NULL    |      |       |
# | updated_at        | 更新日時         | datetime     | NOT NULL    |      |       |
# | preset_key        | 手合割           | string(255)  | NOT NULL    |      |       |
# | start_turn        | 開始局面         | integer(4)   |             |      |       |
# | critical_turn     | 開戦             | integer(4)   |             |      | G     |
# | saturn_key        | 公開範囲         | string(255)  | NOT NULL    |      | H     |
# | sfen_body         | SFEN形式棋譜     | string(8192) |             |      |       |
# | image_turn        | OGP画像の局面    | integer(4)   |             |      |       |
# |-------------------+------------------+--------------+-------------+------+-------|

require 'rails_helper'

RSpec.describe Swars::BattlesController, type: :controller do
  before do
    swars_battle_setup
    @battle = Swars::Battle.first
  end

  it "index" do
    get :index
    expect(response).to have_http_status(:ok)

    get :index, params: {query: "devuser1"}
    expect(response).to have_http_status(:ok)

    get :index, params: {query: "turn_max_gteq:200"}
    expect(response).to have_http_status(:ok)
  end

  it "検索窓にURLを指定" do
    get :index, params: {query: "https://shogiwars.heroz.jp/games/xxx-yyy-20200129_220847?tw=1"}
    expect(response).to have_http_status(:ok)

    get :index, params: {query: "https://kif-pona.heroz.jp/games/xxx-yyy-20200129_220847?tw=1"}
    expect(response).to have_http_status(:ok)
  end

  it "詳細" do
    get :show, params: {id: @battle.to_param}
    expect(response).to have_http_status(:ok)
  end

  it "棋譜印刷" do
    get :show, params: {id: @battle.to_param, formal_sheet: true, formal_sheet_debug: true}
    expect(response).to have_http_status(:ok)
  end

  it "ZIPダウンロード" do
    get :index, params: { query: "devuser1", format: "zip" }
    expect(response).to have_http_status(:ok)
    assert { response.content_type == "application/zip" }
  end

  it "KIF 表示/DL" do
    get :show, params: { id: @battle.to_param, format: "kif" }
    assert { response.content_type == "text/plain" }
    assert { response.body.encoding == Encoding::UTF_8 }
    assert { response.header["Content-Type"] == "text/plain; charset=UTF-8" }
    assert { response.header["Content-Disposition"] == nil }

    get :show, params: { id: @battle.to_param, format: "kif", body_encode: "sjis" }
    assert { response.content_type == "text/plain" }
    assert { response.body.encoding == Encoding::Shift_JIS }
    assert { response.header["Content-Type"] == "text/plain; charset=Shift_JIS" }
    assert { response.header["Content-Disposition"] == nil }

    get :show, params: { id: @battle.to_param, format: "kif", body_encode: "sjis", attachment: "true" }
    assert { response.content_type == "text/plain" }
    assert { response.body.encoding == Encoding::Shift_JIS }
    assert { response.header["Content-Type"] == "text/plain; charset=shift_jis" } # なぜかダウンロードのときだけ小文字に変換される
    assert { response.header["Content-Disposition"].include?("attachment") }
  end
end
