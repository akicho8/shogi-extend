# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+--------------------+----------------+-------------+------------+-------|
# | name          | desc               | type           | opts        | refs       | index |
# |---------------+--------------------+----------------+-------------+------------+-------|
# | id            | ID                 | integer(8)     | NOT NULL PK |            |       |
# | key           | ユニークなハッシュ | string(255)    | NOT NULL    |            | A!    |
# | kifu_url      | 棋譜URL            | string(255)    |             |            |       |
# | kifu_body     | 棋譜               | text(16777215) | NOT NULL    |            |       |
# | turn_max      | 手数               | integer(4)     | NOT NULL    |            | E     |
# | meta_info     | 棋譜ヘッダー       | text(65535)    | NOT NULL    |            |       |
# | battled_at    | Battled at         | datetime       | NOT NULL    |            | D     |
# | outbreak_turn | Outbreak turn      | integer(4)     |             |            | B     |
# | use_key       | Use key            | string(255)    | NOT NULL    |            | C     |
# | accessed_at   | Accessed at        | datetime       | NOT NULL    |            |       |
# | created_at    | 作成日時           | datetime       | NOT NULL    |            |       |
# | updated_at    | 更新日時           | datetime       | NOT NULL    |            |       |
# | user_id       | User               | integer(8)     |             | => User#id | I     |
# | title         | タイトル           | string(255)    |             |            |       |
# | description   | 説明               | text(65535)    | NOT NULL    |            |       |
# | start_turn    | 開始局面           | integer(4)     |             |            | F     |
# | critical_turn | 開戦               | integer(4)     |             |            | G     |
# | saturn_key    | 公開範囲           | string(255)    | NOT NULL    |            | H     |
# | sfen_body     | SFEN形式棋譜       | string(8192)   | NOT NULL    |            |       |
# | image_turn    | OGP画像の局面      | integer(4)     |             |            |       |
# | preset_key    | Preset key         | string(255)    | NOT NULL    |            |       |
# | sfen_hash     | Sfen hash          | string(255)    | NOT NULL    |            |       |
# |---------------+--------------------+----------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe FreeBattlesController, type: :controller do
  before(:context) do
    Actb.setup
  end

  before do
    user_login(key: "sysop")

    @free_battle = FreeBattle.create!
  end

  it "index" do
    get :index
    expect(response).to have_http_status(:ok)
  end

  it "index + modal_id" do
    get :index, params: { modal_id: @free_battle.to_param }
    expect(response).to have_http_status(:ok)
  end

  it "show html" do
    get :show, params: {id: @free_battle.to_param}
    expect(response).to have_http_status(:ok)
  end

  it "show png" do
    get :show, params: {id: @free_battle.to_param, format: "png"}
    expect(response).to have_http_status(:ok)
  end

  it "show png turn" do
    get :show, params: {id: @free_battle.to_param, format: "png", turn: -1}
    expect(response).to have_http_status(:ok)
  end

  it "棋譜印刷" do
    get :show, params: {id: @free_battle.to_param, formal_sheet: true}
    expect(response).to have_http_status(:ok)
  end

  it "new" do
    get :new
    expect(response).to have_http_status(:ok)
  end

  it "コピペ新規" do
    get :new, params: {source_id: @free_battle.to_param}
    expect(response).to have_http_status(:redirect)
  end

  it "なんでも棋譜変換" do
    get :new, params: { edit_mode: "adapter" }
    expect(response).to have_http_status(:ok)
  end

  it "create" do
    post :create, params: {}
    expect(response).to have_http_status(:redirect)
  end

  it "edit" do
    get :edit, params: {id: @free_battle.to_param}
    expect(response).to have_http_status(:ok)
  end

  it "update" do
    put :update, params: {id: @free_battle.to_param}
    expect(response).to have_http_status(:redirect)
  end

  it "destroy" do
    delete :destroy, params: {id: @free_battle.to_param}
    assert { FreeBattle.where(id: @free_battle.to_param).none? }
    expect(response).to have_http_status(:redirect)
  end
end
