# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (fanta_users as Fanta::User)
#
# |---------------+--------------------------------------------------------------------------+-------------+-------------+------+-------|
# | カラム名      | 意味                                                                     | タイプ      | 属性        | 参照 | INDEX |
# |---------------+--------------------------------------------------------------------------+-------------+-------------+------+-------|
# | id            | ID                                                                       | integer(8)  | NOT NULL PK |      |       |
# | key           | Key                                                                      | string(255) | NOT NULL    |      | A!    |
# | name          | 名前                                                                     | string(255) | NOT NULL    |      |       |
# | online_at     | オンラインになった日時                                                   | datetime    |             |      |       |
# | fighting_at   | memberships.fighting_at と同じでこれを見ると対局中かどうかがすぐにわかる | datetime    |             |      |       |
# | matching_at   | マッチング中(開始日時)                                                   | datetime    |             |      |       |
# | cpu_brain_key | Cpu brain key                                                            | string(255) |             |      |       |
# | user_agent    | ブラウザ情報                                                             | string(255) | NOT NULL    |      |       |
# | race_key      | Race key                                                                 | string(255) | NOT NULL    |      | B     |
# | created_at    | 作成日時                                                                 | datetime    | NOT NULL    |      |       |
# | updated_at    | 更新日時                                                                 | datetime    | NOT NULL    |      |       |
# |---------------+--------------------------------------------------------------------------+-------------+-------------+------+-------|

require 'rails_helper'

RSpec.describe Fanta::UsersController, type: :controller do
  before do
    @current_user = user_login
  end

  it "show" do
    get :show, params: {id: @current_user.id}
    expect(response).to have_http_status(:ok)
  end

  it "edit" do
    get :edit, params: {id: @current_user.id}
    expect(response).to have_http_status(:ok)
  end

  it "update" do
    name = SecureRandom.hex
    put :update, params: {id: @current_user.id, fanta_user: {name: name, avatar: fixture_file_upload("spec/rails.png", "image/png")}}
    expect(response).to have_http_status(:redirect)
    @current_user.reload
    assert { @current_user.name == name }
    assert { @current_user.avatar.filename.to_s == "rails.png" }
  end
end
