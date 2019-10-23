# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |-------------------+--------------------+--------------+-------------+-----------------------------------+-------|
# | name              | desc               | type         | opts        | refs                              | index |
# |-------------------+--------------------+--------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)   | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255)  | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255)  |             |                                   |       |
# | kifu_body         | 棋譜               | text(65535)  | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)   | NOT NULL    |                                   | D     |
# | meta_info         | 棋譜ヘッダー       | text(65535)  | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime     | NOT NULL    |                                   | C     |
# | created_at        | 作成日時           | datetime     | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime     | NOT NULL    |                                   |       |
# | colosseum_user_id | 所有者ID           | integer(8)   |             | :owner_user => Colosseum::User#id | B     |
# | title             | 題名               | string(255)  |             |                                   |       |
# | description       | 説明               | text(65535)  | NOT NULL    |                                   |       |
# | start_turn        | 開始局面           | integer(4)   |             |                                   |       |
# | critical_turn     | 開戦               | integer(4)   |             |                                   | E     |
# | saturn_key        | Saturn key         | string(255)  | NOT NULL    |                                   | F     |
# | sfen_body         | Sfen body          | string(8192) |             |                                   |       |
# | image_turn        | OGP画像の局面      | integer(4)   |             |                                   |       |
# |-------------------+--------------------+--------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe FreeBattlesController, type: :controller do
  before do
    user_login(key: "sysop")

    @free_battle = FreeBattle.create!
  end

  it "index" do
    get :index
    expect(response).to have_http_status(:ok)
  end

  it "show" do
    get :show, params: {id: @free_battle.to_param}
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
    get :new, params: {source_id: @free_battle.id}
    expect(response).to have_http_status(:redirect)
  end

  it "create" do
    post :create, params: {}
    expect(response).to have_http_status(:redirect)
  end

  it "edit" do
    get :edit, params: {id: @free_battle.to_param}
    expect(response).to have_http_status(:ok)
  end

  it "OGP設定" do
    get :edit, params: {id: @free_battle.to_param, mode: "ogp"}
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
