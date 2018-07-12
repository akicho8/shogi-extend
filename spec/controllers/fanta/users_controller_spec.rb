# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザー (fanta_users as Fanta::User)
#
# |------------------------+--------------------------------------------------------------------------+-------------+---------------------+------+-------|
# | name                   | desc                                                                     | type        | opts                | refs | index |
# |------------------------+--------------------------------------------------------------------------+-------------+---------------------+------+-------|
# | id                     | ID                                                                       | integer(8)  | NOT NULL PK         |      |       |
# | key                    | Key                                                                      | string(255) | NOT NULL            |      | A!    |
# | name                   | 名前                                                                     | string(255) | NOT NULL            |      |       |
# | online_at              | オンラインになった日時                                                   | datetime    |                     |      |       |
# | fighting_at            | memberships.fighting_at と同じでこれを見ると対局中かどうかがすぐにわかる | datetime    |                     |      |       |
# | matching_at            | マッチング中(開始日時)                                                   | datetime    |                     |      |       |
# | cpu_brain_key          | Cpu brain key                                                            | string(255) |                     |      |       |
# | user_agent             | ブラウザ情報                                                             | string(255) | NOT NULL            |      |       |
# | race_key               | Race key                                                                 | string(255) | NOT NULL            |      | F     |
# | created_at             | 作成日時                                                                 | datetime    | NOT NULL            |      |       |
# | updated_at             | 更新日時                                                                 | datetime    | NOT NULL            |      |       |
# | email                  | Email                                                                    | string(255) | DEFAULT() NOT NULL  |      | B!    |
# | encrypted_password     | Encrypted password                                                       | string(255) | DEFAULT() NOT NULL  |      |       |
# | reset_password_token   | Reset password token                                                     | string(255) |                     |      | C!    |
# | reset_password_sent_at | Reset password sent at                                                   | datetime    |                     |      |       |
# | remember_created_at    | Remember created at                                                      | datetime    |                     |      |       |
# | sign_in_count          | Sign in count                                                            | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | current_sign_in_at     | Current sign in at                                                       | datetime    |                     |      |       |
# | last_sign_in_at        | Last sign in at                                                          | datetime    |                     |      |       |
# | current_sign_in_ip     | Current sign in ip                                                       | string(255) |                     |      |       |
# | last_sign_in_ip        | Last sign in ip                                                          | string(255) |                     |      |       |
# | confirmation_token     | Confirmation token                                                       | string(255) |                     |      | D!    |
# | confirmed_at           | Confirmed at                                                             | datetime    |                     |      |       |
# | confirmation_sent_at   | Confirmation sent at                                                     | datetime    |                     |      |       |
# | unconfirmed_email      | Unconfirmed email                                                        | string(255) |                     |      |       |
# | failed_attempts        | Failed attempts                                                          | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | unlock_token           | Unlock token                                                             | string(255) |                     |      | E!    |
# | locked_at              | Locked at                                                                | datetime    |                     |      |       |
# | provider               | Provider                                                                 | string(255) |                     |      |       |
# | uid                    | Uid                                                                      | string(255) |                     |      |       |
# | auth_info              | Auth info                                                                | text(65535) |                     |      |       |
# |------------------------+--------------------------------------------------------------------------+-------------+---------------------+------+-------|

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
