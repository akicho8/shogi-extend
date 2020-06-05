# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザ (users as User)
#
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | name                   | desc                       | type        | opts                | refs | index |
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | id                     | ID                         | integer(8)  | NOT NULL PK         |      |       |
# | key                    | ユニークなハッシュ         | string(255) | NOT NULL            |      | A!    |
# | name                   | Name                       | string(255) | NOT NULL            |      |       |
# | online_at              | Online at                  | datetime    |                     |      |       |
# | fighting_at            | Fighting at                | datetime    |                     |      |       |
# | matching_at            | Matching at                | datetime    |                     |      |       |
# | cpu_brain_key          | Cpu brain key              | string(255) |                     |      |       |
# | user_agent             | User agent                 | string(255) | NOT NULL            |      |       |
# | race_key               | Race key                   | string(255) | NOT NULL            |      | F     |
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
# | joined_at              | Joined at                  | datetime    |                     |      |       |
# |------------------------+----------------------------+-------------+---------------------+------+-------|

require "tsl"

module Tsl
  class User < ApplicationRecord
    has_many :memberships, dependent: :destroy, inverse_of: :user # 対局時の情報(複数)
    has_many :leagues, through: :memberships                      # 対局(複数)

    def name_with_age
      s = name
      if first_age && last_age
        s += "(#{first_age}-#{last_age})"
      end
      s
    end
  end
end
