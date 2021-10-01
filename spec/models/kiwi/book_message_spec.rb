# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Book message (kiwi_book_messages as Kiwi::BookMessage)
#
# |------------+----------+-------------+-------------+--------------+-------|
# | name       | desc     | type        | opts        | refs         | index |
# |------------+----------+-------------+-------------+--------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User     | integer(8)  | NOT NULL    | => ::User#id | A     |
# | book_id    | Book     | integer(8)  | NOT NULL    |              | B     |
# | body       | 内容     | string(512) | NOT NULL    |              |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |              |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |              |       |
# |------------+----------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

module Kiwi
  RSpec.describe BookMessage, type: :model do
    include KiwiSupport
    include MailerSupport

    it "コメントするとメール送信する" do
      Folder.setup
      perform_enqueued_jobs { book1.book_messages.create!(user: user2, body: "message") } # user1 さんのに user2 さんがコメント
      assert { deliveries.count == 1 }                                                    # 1件送信された
      assert { deliveries.last.from == ["shogi.extend@gmail.com"] }                       # from は運営のメール
      assert { deliveries.last.to == ["user1@localhost"] }                                # to は動画のオーナー user1

      perform_enqueued_jobs { book1.book_messages.create!(user: user3, body: "message") } # user3 が続けてコメント
      assert { deliveries.count == 1+2 }                                                  # 追加で2件送られている

      assert { deliveries.second.subject == "user3さんが「アヒル」にコメントしました"                 }
      assert { deliveries.second.to      == ["user1@localhost"]                                       }
      assert { deliveries.third.subject  == "以前コメントした「アヒル」にuser3さんがコメントしました" }
      assert { deliveries.third.to       == ["user2@localhost"]                                       }

      tp deliveries_info if $0 == "-"
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> |----------------------------+---------------------+---------------------------------------------------------+------------|
# >> | from                       | to                  | subject                                                 | body       |
# >> |----------------------------+---------------------+---------------------------------------------------------+------------|
# >> | ["shogi.extend@gmail.com"] | ["user1@localhost"] | user2さんが「アヒル」にコメントしました                 | message... |
# >> | ["shogi.extend@gmail.com"] | ["user1@localhost"] | user3さんが「アヒル」にコメントしました                 | message... |
# >> | ["shogi.extend@gmail.com"] | ["user2@localhost"] | 以前コメントした「アヒル」にuser3さんがコメントしました | message... |
# >> |----------------------------+---------------------+---------------------------------------------------------+------------|
# >> .
# >>
# >> Top 1 slowest examples (1.66 seconds, 47.9% of total time):
# >>   Kiwi::BookMessage コメントするとメール送信する
# >>     1.66 seconds -:28
# >>
# >> Finished in 3.47 seconds (files took 3.36 seconds to load)
# >> 1 example, 0 failures
# >>
