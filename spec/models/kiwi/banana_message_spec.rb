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
      assert { banana1.updated_at == "2000-01-01".to_time }
      Timecop.freeze("2000-01-02") { banana1.banana_messages.create!(user: user1) }
      assert { banana1.reload.updated_at == "2000-01-02".to_time }
    end

    it "コメントするとメール送信する" do
      perform_enqueued_jobs { banana1.banana_messages.create!(user: user2, body: "message") } # user1 さんのに user2 さんがコメント
      assert { deliveries.count == 1 }                                                    # 1件送信された
      assert { deliveries.last.from == ["shogi.extend@gmail.com"] }                       # from は運営のメール
      assert { deliveries.last.to == ["user1@localhost"] }                                # to は動画のオーナー user1

      perform_enqueued_jobs { banana1.banana_messages.create!(user: user3, body: "message") } # user3 が続けてコメント
      assert { deliveries.count == 1+2 }                                                  # 追加で2件送られている

      assert { deliveries.second.subject == "user3さんが「アヒル」にコメントしました"                 }
      assert { deliveries.second.to      == ["user1@localhost"]                                       }
      assert { deliveries.third.subject  == "以前コメントした「アヒル」にuser3さんがコメントしました" }
      assert { deliveries.third.to       == ["user2@localhost"]                                       }

      tp deliveries_info if $0 == "-"
    end
  end
end
