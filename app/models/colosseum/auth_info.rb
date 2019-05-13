# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Auth info (colosseum_auth_infos as Colosseum::AuthInfo)
#
# |-----------+--------------+-------------+-------------+------+-------|
# | name      | desc         | type        | opts        | refs | index |
# |-----------+--------------+-------------+-------------+------+-------|
# | id        | ID           | integer(8)  | NOT NULL PK |      |       |
# | user_id   | User         | integer(8)  | NOT NULL    |      | B     |
# | provider  | プロバイダー | string(255) | NOT NULL    |      | A!    |
# | uid       | UID          | string(255) | NOT NULL    |      | A!    |
# | meta_info | 棋譜ヘッダー | text(65535) |             |      |       |
# |-----------+--------------+-------------+-------------+------+-------|

module Colosseum
  class AuthInfo < ApplicationRecord
    belongs_to :user

    serialize :meta_info

    attr_accessor :auth

    before_validation do
      if auth
        self.provider  = auth.provider
        self.uid       = auth.uid
        self.meta_info = auth.to_hash # ここで allocator undefined for Proc がでている……？？？ 出ないときもある。よくわからん
      end
    end

    with_options presence: true do
      validates :provider
      validates :uid
    end

    with_options allow_blank: true do
      validates :uid, uniqueness: {scope: :provider, message: "が重複しています。すでに他のアカウントと連携しているようです。いったんログアウトしてそのアカウントを使うか、そのアカウントとの連携を解除してからこちらと連携してみてください"}
    end
  end
end
