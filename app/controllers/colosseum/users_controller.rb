# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザー (colosseum_users as Colosseum::User)
#
# |------------------------+--------------------------+-------------+---------------------+------+-------|
# | name                   | desc                     | type        | opts                | refs | index |
# |------------------------+--------------------------+-------------+---------------------+------+-------|
# | id                     | ID                       | integer(8)  | NOT NULL PK         |      |       |
# | key                    | Key                      | string(255) | NOT NULL            |      | A!    |
# | name                   | 名前                     | string(255) | NOT NULL            |      |       |
# | online_at              | オンラインになった日時   | datetime    |                     |      |       |
# | fighting_at            | 入室しているなら入室日時 | datetime    |                     |      |       |
# | matching_at            | マッチング中(開始日時)   | datetime    |                     |      |       |
# | cpu_brain_key          | CPUの思考タイプ          | string(255) |                     |      |       |
# | user_agent             | ブラウザ情報             | string(255) | NOT NULL            |      |       |
# | race_key               | 種族                     | string(255) | NOT NULL            |      | F     |
# | created_at             | 作成日時                 | datetime    | NOT NULL            |      |       |
# | updated_at             | 更新日時                 | datetime    | NOT NULL            |      |       |
# | email                  | メールアドレス           | string(255) | NOT NULL            |      | B!    |
# | encrypted_password     | Encrypted password       | string(255) | NOT NULL            |      |       |
# | reset_password_token   | Reset password token     | string(255) |                     |      | C!    |
# | reset_password_sent_at | Reset password sent at   | datetime    |                     |      |       |
# | remember_created_at    | Remember created at      | datetime    |                     |      |       |
# | sign_in_count          | Sign in count            | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | current_sign_in_at     | Current sign in at       | datetime    |                     |      |       |
# | last_sign_in_at        | Last sign in at          | datetime    |                     |      |       |
# | current_sign_in_ip     | Current sign in ip       | string(255) |                     |      |       |
# | last_sign_in_ip        | Last sign in ip          | string(255) |                     |      |       |
# | confirmation_token     | Confirmation token       | string(255) |                     |      | D!    |
# | confirmed_at           | Confirmed at             | datetime    |                     |      |       |
# | confirmation_sent_at   | Confirmation sent at     | datetime    |                     |      |       |
# | unconfirmed_email      | Unconfirmed email        | string(255) |                     |      |       |
# | failed_attempts        | Failed attempts          | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | unlock_token           | Unlock token             | string(255) |                     |      | E!    |
# | locked_at              | Locked at                | datetime    |                     |      |       |
# |------------------------+--------------------------+-------------+---------------------+------+-------|

module Colosseum
  class UsersController < ApplicationController
    include ModulableCrud::All

    before_action only: [:index] do
      unless sysop?
        redirect_to :root, alert: "アクセス権限がありません"
      end
    end

    before_action only: [:edit, :update, :destroy] do
      unless current_user == current_record
        unless Rails.env.test?
          redirect_to :root, alert: "アクセス権限がありません"
        end
      end
    end

    let :js_user_profile do
      ams_sr(current_record, serializer: UserProfileSerializer, include: {battles: {memberships: :user}})
    end

    def update
      if params[:command] == "social_connect"
        session[:return_to] = polymorphic_path([:edit, current_record])
        redirect_to omniauth_authorize_path(:xuser, social_media_info.key)
        return
      end

      if params[:command] == "social_disconnect"
        current_record.auth_infos.where(provider: social_media_info.key).destroy_all
        redirect_to polymorphic_path([:edit, current_record]), notice: "#{social_media_info.name} アカウントとの連携を解除しました"
        return
      end

      super
    end

    private

    def social_media_info
      SocialMediaInfo.fetch(params[:provider])
    end
  end
end
