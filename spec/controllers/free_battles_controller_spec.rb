# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜入力 (free_battles as FreeBattle)
#
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | name              | desc               | type        | opts        | refs                              | index |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)  | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255) | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255) |             |                                   |       |
# | kifu_body         | 棋譜               | text(65535) | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)  | NOT NULL    |                                   |       |
# | meta_info         | 棋譜ヘッダー       | text(65535) | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime    | NOT NULL    |                                   |       |
# | created_at        | 作成日時           | datetime    | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime    | NOT NULL    |                                   |       |
# | colosseum_user_id | Colosseum user     | integer(8)  |             | :owner_user => Colosseum::User#id | B     |
# | title             | タイトル           | string(255) |             |                                   |       |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# 【警告:リレーション欠如】Colosseum::Userモデルで has_many :free_battles, :foreign_key => :colosseum_user_id されていません
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

  it "new" do
    get :new
    expect(response).to have_http_status(:ok)
  end

  it "新規でコピペ" do
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

  it "update" do
    put :update, params: {id: @free_battle.to_param}
    expect(response).to have_http_status(:redirect)
  end

  it "destroy" do
    delete :destroy, params: {id: @free_battle.to_param}
    expect(response).to have_http_status(:redirect)
  end
end
