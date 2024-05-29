# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザー (users as User)
#
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | name                   | desc                       | type        | opts                | refs | index |
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | id                     | ID                         | integer(8)  | NOT NULL PK         |      |       |
# | key                    | キー                       | string(255) | NOT NULL            |      | A!    |
# | name                   | 名前                       | string(255) | NOT NULL            |      |       |
# | user_agent             | User agent                 | string(255) | NOT NULL            |      |       |
# | race_key               | 種族                       | string(255) | NOT NULL            |      | F     |
# | name_input_at          | Name input at              | datetime    |                     |      |       |
# | created_at             | 作成日                     | datetime    | NOT NULL            |      |       |
# | updated_at             | 更新日                     | datetime    | NOT NULL            |      |       |
# | email                  | メールアドレス             | string(255) | NOT NULL            |      | B!    |
# | encrypted_password     | 暗号化パスワード           | string(255) | NOT NULL            |      |       |
# | reset_password_token   | Reset password token       | string(255) |                     |      | C!    |
# | reset_password_sent_at | パスワードリセット送信時刻 | datetime    |                     |      |       |
# | remember_created_at    | ログイン記憶時刻           | datetime    |                     |      |       |
# | sign_in_count          | ログイン回数               | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | current_sign_in_at     | 現在のログイン時刻         | datetime    |                     |      |       |
# | last_sign_in_at        | 最終ログイン時刻           | datetime    |                     |      |       |
# | current_sign_in_ip     | 現在のログインIPアドレス   | string(255) |                     |      |       |
# | last_sign_in_ip        | 最終ログインIPアドレス     | string(255) |                     |      |       |
# | confirmation_token     | パスワード確認用トークン   | string(255) |                     |      | D!    |
# | confirmed_at           | パスワード確認時刻         | datetime    |                     |      |       |
# | confirmation_sent_at   | パスワード確認送信時刻     | datetime    |                     |      |       |
# | unconfirmed_email      | 未確認Eメール              | string(255) |                     |      |       |
# | failed_attempts        | 失敗したログイン試行回数   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | unlock_token           | Unlock token               | string(255) |                     |      | E!    |
# | locked_at              | ロック時刻                 | datetime    |                     |      |       |
# |------------------------+----------------------------+-------------+---------------------+------+-------|

class UsersController < ApplicationController
  include ModulableCrud::All

  skip_before_action :user_name_required, action: [:edit, :update]

  before_action only: [:index] do
    if !admin?
      redirect_to :root, alert: "アクセス権限がありません"
    end
  end

  before_action only: [:edit, :update, :destroy] do
    if current_user != current_record
      if !Rails.env.test?
        redirect_to :root, alert: "アクセス権限がありません"
      end
    end
  end

  def update
    if params[:command] == "social_connect"
      session[:return_to] = polymorphic_path([:edit, current_record])
      redirect_to omniauth_authorize_path(:xuser, social_media_info.key)
      return
    end

    if params[:command] == "social_disconnect"
      if current_record.auth_infos.one?
        redirect_to polymorphic_path([:edit, current_record]), alert: "最後の1つのアカウント連携を解除してしまうとログインできなくなってしまいます"
        return
      end
      current_record.auth_infos.where(provider: social_media_info.key).destroy_all
      redirect_to polymorphic_path([:edit, current_record]), notice: "#{social_media_info.name} アカウントとの連携を解除しました"
      return
    end

    super
  end

  private

  def redirect_to_where
    [:edit, ns_prefix, current_record]
  end

  def social_media_info
    SocialMediaInfo.fetch(params[:provider])
  end
end
