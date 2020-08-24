# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Question message (xclock_question_messages as Xclock::QuestionMessage)
#
# |-------------+----------+-------------+-------------+--------------+-------|
# | name        | desc     | type        | opts        | refs         | index |
# |-------------+----------+-------------+-------------+--------------+-------|
# | id          | ID       | integer(8)  | NOT NULL PK |              |       |
# | user_id     | User     | integer(8)  | NOT NULL    | => ::User#id | A     |
# | question_id | Question | integer(8)  | NOT NULL    |              | B     |
# | body        | 内容     | string(512) | NOT NULL    |              |       |
# | created_at  | 作成日時 | datetime    | NOT NULL    |              |       |
# | updated_at  | 更新日時 | datetime    | NOT NULL    |              |       |
# |-------------+----------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

module Xclock
  RSpec.describe QuestionMessage, type: :model do
    include XclockSupportMethods
    include ActiveJob::TestHelper

    it "コメントするとメール送信する" do
      perform_enqueued_jobs do
        question1.messages.create!(user: user2, body: "message")
      end

      assert { ActionMailer::Base.deliveries.count == 1 }
      mail = ActionMailer::Base.deliveries.last
      assert { mail.to      == ["user1@localhost"] }
      # tp ActionMailer::Base.deliveries.collect { |e| {subject: e.subject, from: e.from, to: e.to} }
      ActionMailer::Base.deliveries.clear

      # 続けて第三者がコメント
      perform_enqueued_jobs do
        question1.messages.create!(user: user3, body: "message")
      end
      assert { ActionMailer::Base.deliveries.count == 2 }

      # tp ActionMailer::Base.deliveries.collect { |e| {subject: e.subject, from: e.from, to: e.to} }

      mail = ActionMailer::Base.deliveries.first
      assert { mail.to == ["user1@localhost"] }

      mail = ActionMailer::Base.deliveries.second
      assert { mail.to == ["user2@localhost"] }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> |-------------------------------------------+----------------------------+---------------------|
# >> | subject                                   | from                       | to                  |
# >> |-------------------------------------------+----------------------------+---------------------|
# >> | user2さんが「(title1)」にコメントしました | ["shogi.extend@gmail.com"] | ["user1@localhost"] |
# >> |-------------------------------------------+----------------------------+---------------------|
# >> |-------------------------------------------------------------+----------------------------+---------------------|
# >> | subject                                                     | from                       | to                  |
# >> |-------------------------------------------------------------+----------------------------+---------------------|
# >> | user3さんが「(title1)」にコメントしました                   | ["shogi.extend@gmail.com"] | ["user1@localhost"] |
# >> | 以前コメントした「(title1)」にuser3さんがにコメントしました | ["shogi.extend@gmail.com"] | ["user2@localhost"] |
# >> |-------------------------------------------------------------+----------------------------+---------------------|
# >> .
# >>
# >> Finished in 0.77753 seconds (files took 2.15 seconds to load)
# >> 1 example, 0 failures
# >>
