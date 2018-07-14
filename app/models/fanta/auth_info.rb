# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Auth info (fanta_auth_infos as Fanta::AuthInfo)
#
# |-----------+-----------+-------------+-------------+------+-------|
# | name      | desc      | type        | opts        | refs | index |
# |-----------+-----------+-------------+-------------+------+-------|
# | id        | ID        | integer(8)  | NOT NULL PK |      |       |
# | user_id   | User      | integer(8)  | NOT NULL    |      | B     |
# | provider  | Provider  | string(255) | NOT NULL    |      | A!    |
# | uid       | Uid       | string(255) | NOT NULL    |      | A!    |
# | meta_info | Meta info | text(65535) |             |      |       |
# |-----------+-----------+-------------+-------------+------+-------|

module Fanta
  class AuthInfo < ApplicationRecord
    belongs_to :user

    serialize :meta_info

    with_options presence: true do
      validates :provider
      validates :uid
    end

    with_options allow_blank: true do
      validates :uid, uniqueness: {scope: :provider}
    end
  end
end
