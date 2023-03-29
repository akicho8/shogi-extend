# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Banana message (kiwi_banana_messages as Kiwi::BananaMessage)
#
# |------------+----------+-------------+-------------+--------------+-------|
# | name       | desc     | type        | opts        | refs         | index |
# |------------+----------+-------------+-------------+--------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User     | integer(8)  | NOT NULL    | => ::User#id | B     |
# | banana_id  | Banana   | integer(8)  | NOT NULL    |              | A! C  |
# | body       | 内容     | string(512) | NOT NULL    |              |       |
# | position   | 順序     | integer(4)  | NOT NULL    |              | A! D  |
# | deleted_at | 削除日時 | datetime    |             |              |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |              |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |              |       |
# |------------+----------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

module Kiwi
  RSpec.describe BananaMessage, type: :model, kiwi: true do
    include KiwiSupport
    include MailerSupport

    it "コメントすると動画の更新日時も更新する" do
      assert2 { banana1.updated_at == "2000-01-01".to_time }
      Timecop.freeze("2000-01-02") { banana1.banana_messages.create!(user: user1) }
      assert2 { banana1.reload.updated_at == "2000-01-02".to_time }
    end

    it "コメントするとメール送信する" do
      perform_enqueued_jobs { banana1.banana_messages.create!(user: user2, body: "message") } # user1 さんのに user2 さんがコメント
      assert2 { deliveries.count == 1 }                                                    # 1件送信された
      assert2 { deliveries.last.from == ["shogi.extend@gmail.com"] }                       # from は運営のメール
      assert2 { deliveries.last.to == ["user1@localhost"] }                                # to は動画のオーナー user1

      perform_enqueued_jobs { banana1.banana_messages.create!(user: user3, body: "message") } # user3 が続けてコメント
      assert2 { deliveries.count == 1+2 }                                                  # 追加で2件送られている

      assert2 { deliveries.second.subject == "📝user3さんが「アヒル」にコメントしました"                 }
      assert2 { deliveries.second.to      == ["user1@localhost"]                                       }
      assert2 { deliveries.third.subject  == "📝以前コメントした「アヒル」にuser3さんがコメントしました" }
      assert2 { deliveries.third.to       == ["user2@localhost"]                                       }

      tp deliveries_info if $0 == "-"
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> .F
# >> 
# >> Failures:
# >> 
# >>   1) Kiwi::BananaMessage コメントするとメール送信する
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:48:in `block (2 levels) in <module:Kiwi>'
# >>      # ./spec/support/database_cleaner.rb:22:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:22:in `block (2 levels) in <main>'
# >> 
# >> Top 2 slowest examples (2.65 seconds, 54.5% of total time):
# >>   Kiwi::BananaMessage コメントすると動画の更新日時も更新する
# >>     1.76 seconds -:30
# >>   Kiwi::BananaMessage コメントするとメール送信する
# >>     0.89121 seconds -:36
# >> 
# >> Finished in 4.86 seconds (files took 3.63 seconds to load)
# >> 2 examples, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:36 # Kiwi::BananaMessage コメントするとメール送信する
# >> 
