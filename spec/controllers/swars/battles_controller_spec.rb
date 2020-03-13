# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |---------------+------------------+--------------+-------------+------+-------|
# | name          | desc             | type         | opts        | refs | index |
# |---------------+------------------+--------------+-------------+------+-------|
# | id            | ID               | integer(8)   | NOT NULL PK |      |       |
# | key           | 対局ユニークキー | string(255)  | NOT NULL    |      | A!    |
# | battled_at    | 対局日時         | datetime     | NOT NULL    |      | F     |
# | rule_key      | ルール           | string(255)  | NOT NULL    |      | B     |
# | csa_seq       | 棋譜             | text(65535)  | NOT NULL    |      |       |
# | final_key     | 結末             | string(255)  | NOT NULL    |      | C     |
# | win_user_id   | 勝者             | integer(8)   |             |      | D     |
# | turn_max      | 手数             | integer(4)   | NOT NULL    |      | G     |
# | meta_info     | メタ情報         | text(65535)  | NOT NULL    |      |       |
# | accessed_at   | 最終アクセス日時 | datetime     | NOT NULL    |      |       |
# | outbreak_turn | Outbreak turn    | integer(4)   |             |      | E     |
# | created_at    | 作成日時         | datetime     | NOT NULL    |      |       |
# | updated_at    | 更新日時         | datetime     | NOT NULL    |      |       |
# | preset_key    | 手合割           | string(255)  | NOT NULL    |      |       |
# | start_turn    | 開始局面         | integer(4)   |             |      |       |
# | critical_turn | 開戦             | integer(4)   |             |      | H     |
# | saturn_key    | 公開範囲         | string(255)  | NOT NULL    |      | I     |
# | sfen_body     | SFEN形式棋譜     | string(8192) |             |      |       |
# | image_turn    | OGP画像の局面    | integer(4)   |             |      |       |
# |---------------+------------------+--------------+-------------+------+-------|

require 'rails_helper'

RSpec.describe Swars::BattlesController, type: :controller do
  before do
    swars_battle_setup
    @battle = Swars::Battle.first
  end

  it "index" do
    get :index
    expect(response).to have_http_status(:ok)
  end

  it "index + query" do
    get :index, params: {query: "devuser1"}
    expect(response).to have_http_status(:ok)
    assert { assigns(:current_records).size == 1 }
    assert { assigns(:current_records).first.tournament_name == "将棋ウォーズ(10分)" }
  end

  it "index + tag" do
    get :index, params: {query: "turn_max_gteq:200"}
    expect(response).to have_http_status(:ok)
  end

  it "index + modal_id" do
    get :index, params: {modal_id: @battle.to_param}
    expect(response).to have_http_status(:ok)
  end

  it "KENTO棋譜リストAPI" do
    get :index, params: { query: "devuser1", format: "json", format_type: "kento" }
    expect(response).to have_http_status(:ok)
    assert { JSON.parse(response.body) == {"api_version"=>"2020-02-02", "api_name"=>"将棋ウォーズ(ID:devuser1)", "game_list"=>[{"tag"=>["将棋ウォーズ(10分)", "勝ち"], "kifu_url"=>"http://test.host/w/devuser1-Yamada_Taro-20190111_230933.kif", "display_name"=>"devuser1 三段 vs Yamada_Taro 四段", "display_timestamp"=>1547215773}]} }
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

  it "png" do
    get :show, params: {id: @battle.to_param, format: "png", width: "", turn: 999}
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
