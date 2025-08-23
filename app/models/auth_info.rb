# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Auth info (auth_infos as AuthInfo)
#
# |-----------+----------------+-------------+-------------+------------+-------|
# | name      | desc           | type        | opts        | refs       | index |
# |-----------+----------------+-------------+-------------+------------+-------|
# | id        | ID             | integer(8)  | NOT NULL PK |            |       |
# | user_id   | User           | integer(8)  | NOT NULL    | => User#id | B     |
# | provider  | プロバイダ     | string(255) | NOT NULL    |            | A!    |
# | uid       | 識別子         | string(255) | NOT NULL    |            | A!    |
# | meta_info | 認証情報(JSON) | text(65535) |             |            |       |
# |-----------+----------------+-------------+-------------+------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# --------------------------------------------------------------------------------

class AuthInfo < ApplicationRecord
  belongs_to :user

  serialize :meta_info, coder: JSON

  attr_accessor :auth

  before_validation do
    if auth
      self.provider  ||= auth.provider
      self.uid       ||= auth.uid
      self.meta_info ||= auth # auth.info だけあれば充分だが調査用にとっておく
    end
  end

  with_options presence: true do
    validates :provider
    validates :uid
  end

  with_options allow_blank: true do
    validates :uid, uniqueness: { scope: :provider, case_sensitive: true, message: "が重複しています。すでに他のアカウントと連携しているようです。いったんログアウトしてそのアカウントを使うか、そのアカウントとの連携を解除してからこちらと連携してみてください" }
  end

  # # 初めてTwitter経由ログインしたとき自己紹介が空だったらコピーする
  # after_create do
  #   if meta_info
  #     # profile = user.profile
  #     # if v = meta_info.dig("info", "description")
  #     #   if profile.description.blank?
  #     #     profile.description = v
  #     #   end
  #     # end
  #     # if provider == "twitter"
  #     #   if v = meta_info.dig("info", "nickname")
  #     #     if profile.twitter_key.blank?
  #     #       profile.twitter_key = v
  #     #     end
  #     #   end
  #     # end
  #
  #     #
  #     # OmniauthCallbacksController で毎回ログイン時に設定するように変更したので不要
  #     #
  #     # if v = meta_info.dig("info", "email")
  #     #   if user.email_invalid?
  #     #     user.email = v
  #     #     user.skip_reconfirmation! # email に設定した内容が unconfirmed_email に退避されるのを防ぐ
  #     #     user.save!
  #     #   end
  #     # end
  #   end
  # end

  def app_logging
    AppLog.info(subject: "[SNS経由登録][#{provider}] #{user.name.inspect} (AuthInfo.create!)", body: [user.info.to_t, meta_info.pretty_inspect].join("\n"))
  end
  after_create_commit :app_logging
end
