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

require "rails_helper"

module Swars
  RSpec.describe User, type: :model, swars_spec: true do
    it "ユーザー名は大小文字を区別する" do
      User.create!(key: "ALICE")
      assert { User.new(key: "alice").valid? }
    end

    it ".[](key)" do
      User.create!(key: "alice")
      assert { User["alice"] }
      assert { !User["bob"] }
    end

    it ".fetch(key)" do
      User.create!(key: "alice")
      assert { User.fetch("alice") }
    end

    it "key_info" do
      assert { User.create!(key: "alice").key_info }
    end

    describe "垢BAN" do
      it "ban!: 垢BANすると二箇所の user.ban_at と profile.ban_at をセットする" do
        user = User.create!
        user.ban!
        user.reload
        user.profile.reload

        assert { user.ban_at }
        assert { user.profile.ban_at }
        assert { user.profile.ban_crawled_at }
        assert { user.profile.ban_crawled_count == 1 }
      end

      it "ban_reset: 垢BANも確認もしていない状態に戻す" do
        user = User.create!
        user.ban!
        user.ban_reset
        user.reload
        assert { user.ban_at == nil }
        assert { user.profile.ban_at == nil }
        assert { user.profile.ban_crawled_count == 0 }
        assert { user.profile.ban_crawled_at }
      end
    end

    it "対局作成時にその対局の対局日時の方が新しければユーザーが1つ保持している最終対局日時を更新する" do
      battled_at = "2024-01-01".to_time
      battle = Battle.create!(battled_at: battled_at).reload
      assert { battle.memberships[0].user.latest_battled_at == battled_at }
      assert { battle.memberships[1].user.latest_battled_at == battled_at }
    end
  end
end
