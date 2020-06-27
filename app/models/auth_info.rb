# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Auth info (auth_infos as AuthInfo)
#
# |-----------+--------------+-------------+-------------+------------+-------|
# | name      | desc         | type        | opts        | refs       | index |
# |-----------+--------------+-------------+-------------+------------+-------|
# | id        | ID           | integer(8)  | NOT NULL PK |            |       |
# | user_id   | User         | integer(8)  | NOT NULL    | => User#id | B     |
# | provider  | Provider     | string(255) | NOT NULL    |            | A!    |
# | uid       | Uid          | string(255) | NOT NULL    |            | A!    |
# | meta_info | 棋譜ヘッダー | text(65535) |             |            |       |
# |-----------+--------------+-------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

class AuthInfo < ApplicationRecord
  belongs_to :user

  serialize :meta_info

  attr_accessor :auth

  before_validation do
    if auth
      self.provider  = auth.provider
      self.uid       = auth.uid
      self.meta_info = auth.as_json # as_json することで Proc オブジェクトを除外する。含まれていると allocator undefined for Proc エラーになる
    end
  end

  with_options presence: true do
    validates :provider
    validates :uid
  end

  with_options allow_blank: true do
    validates :uid, uniqueness: { scope: :provider, case_sensitive: true, message: "が重複しています。すでに他のアカウントと連携しているようです。いったんログアウトしてそのアカウントを使うか、そのアカウントとの連携を解除してからこちらと連携してみてください" }
  end

  # 初めてTwitter経由ログインしたとき自己紹介が空だったらコピーする
  after_create do
    if meta_info
      if v = meta_info.dig("info", "description")
        if user.profile.description.blank?
          user.profile.description = v
        end
      end
      if provider == "twitter"
        if v = meta_info.dig("info", "nickname")
          if user.profile.twitter_key.blank?
            user.profile.twitter_key = v
          end
        end
      end
      user.profile.save!
    end
  end

  after_create_commit do
    UserMailer.user_created(user).deliver_later
  end
end
