# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザーテーブル (fanta_users as Fanta::User)
#
# |-------------------+-----------------+-------------+-------------+------+-------|
# | カラム名          | 意味            | タイプ      | 属性        | 参照 | INDEX |
# |-------------------+-----------------+-------------+-------------+------+-------|
# | id                | ID              | integer(8)  | NOT NULL PK |      |       |
# | name              | Name            | string(255) | NOT NULL    |      |       |
# | current_battle_id | Current battle  | integer(8)  |             |      | A     |
# | online_at         | Online at       | datetime    |             |      |       |
# | fighting_at       | Fighting at     | datetime    |             |      |       |
# | matching_at       | Matching at     | datetime    |             |      |       |
# | lifetime_key      | Lifetime key    | string(255) | NOT NULL    |      | B     |
# | platoon_key       | Platoon key     | string(255) | NOT NULL    |      | C     |
# | self_preset_key   | Self preset key | string(255) | NOT NULL    |      | D     |
# | oppo_preset_key   | Oppo preset key | string(255) | NOT NULL    |      | E     |
# | user_agent        | User agent      | string(255) | NOT NULL    |      |       |
# | created_at        | 作成日時        | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時        | datetime    | NOT NULL    |      |       |
# |-------------------+-----------------+-------------+-------------+------+-------|

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
