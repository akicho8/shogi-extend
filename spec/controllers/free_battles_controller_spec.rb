# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (free_battles as FreeBattle)
#
# |------------+--------------------+-------------+-------------+------+-------|
# | カラム名   | 意味               | タイプ      | 属性        | 参照 | INDEX |
# |------------+--------------------+-------------+-------------+------+-------|
# | id         | ID                 | integer(8)  | NOT NULL PK |      |       |
# | key        | ユニークなハッシュ | string(255) | NOT NULL    |      | A!    |
# | kifu_url   | 棋譜URL            | string(255) |             |      |       |
# | kifu_body  | 棋譜内容           | text(65535) | NOT NULL    |      |       |
# | turn_max   | 手数               | integer(4)  | NOT NULL    |      |       |
# | meta_info  | 棋譜ヘッダー       | text(65535) | NOT NULL    |      |       |
# | battled_at | Battled at         | datetime    | NOT NULL    |      |       |
# | created_at | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時           | datetime    | NOT NULL    |      |       |
# |------------+--------------------+-------------+-------------+------+-------|

require 'rails_helper'

RSpec.describe FreeBattlesController, type: :controller do
  before do
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
