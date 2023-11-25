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

require "rails_helper"

module Swars
  RSpec.describe Profile, type: :model, swars_spec: true do
    it "ユーザーを作るとprofileモデルも同時に作りリレーションが正しい" do
      user = User.create!
      assert2 { user.profile }
      assert2 { user.profile.user == user }
      assert2 { user.profile.ban_crawled_count == 0 }
      assert2 { user.profile.ban_at == nil }
      assert2 { user.profile.ban_crawled_at }
    end

    describe "垢BAN" do
      it "ban_crawled_at を更新すると ban_crawled_count をインクリメントする" do
        user = User.create!
        user.profile.ban_crawled_at = Time.current
        user.save!
        assert2 { user.profile.ban_crawled_count == 1 }
      end

      it "ban_crawled_count_lteq: 垢BANチェック指定回数以下" do
        user = User.create!
        Profile.ban_crawled_count_lteq(0) == [user.profile]
      end

      it "ban_crawled_at_lt: 垢BANチェックの前回が指定日時より過去" do
        user = User.create!
        assert2 { Profile.ban_crawled_at_lt(user.profile.ban_crawled_at).count == 0     } # ban_crawled_at < ban_crawled_at     なので 0
        assert2 { Profile.ban_crawled_at_lt(user.profile.ban_crawled_at + 1).count == 1 } # ban_crawled_at < ban_crawled_at + 1 なので 1
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::Profile
# >>   ユーザーを作るとprofileモデルも同時に作りリレーションが正しい (FAILED - 1)
# >>   垢BAN
# >>     ban_crawled_at を更新すると ban_crawled_count をインクリメントする
# >>     ban_crawled_count_lteq: 垢BANチェック指定回数以下
# >>     ban_crawled_at_lt: 垢BANチェックの前回が指定日時より過去 (FAILED - 2)
# >>
# >> Failures:
# >>
# >>   1) Swars::Profile ユーザーを作るとprofileモデルも同時に作りリレーションが正しい
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:46:in `block (2 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >>
# >>   2) Swars::Profile 垢BAN ban_crawled_at_lt: 垢BANチェックの前回が指定日時より過去
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:66:in `block (3 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >>
# >> Top 4 slowest examples (0.45333 seconds, 18.0% of total time):
# >>   Swars::Profile ユーザーを作るとprofileモデルも同時に作りリレーションが正しい
# >>     0.1756 seconds -:40
# >>   Swars::Profile 垢BAN ban_crawled_at_lt: 垢BANチェックの前回が指定日時より過去
# >>     0.1344 seconds -:64
# >>   Swars::Profile 垢BAN ban_crawled_at を更新すると ban_crawled_count をインクリメントする
# >>     0.08252 seconds -:52
# >>   Swars::Profile 垢BAN ban_crawled_count_lteq: 垢BANチェック指定回数以下
# >>     0.06082 seconds -:59
# >>
# >> Finished in 2.52 seconds (files took 1.64 seconds to load)
# >> 4 examples, 2 failures
# >>
# >> Failed examples:
# >>
# >> rspec -:40 # Swars::Profile ユーザーを作るとprofileモデルも同時に作りリレーションが正しい
# >> rspec -:64 # Swars::Profile 垢BAN ban_crawled_at_lt: 垢BANチェックの前回が指定日時より過去
# >>
