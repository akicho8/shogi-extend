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

module Xclock
  class QuestionMessage < ApplicationRecord
    include MessageShared

    belongs_to :question, counter_cache: :messages_count

    after_create_commit do
      Xclock::QuestionMessageBroadcastJob.perform_later(self)

      # 作者に通知
      if true
        if question.user != user
          if question.user.email_valid? || Rails.env.test?
            UserMailer.question_owner_message(self).deliver_later
          end
          question.user.notifications.create!(question_message: self)
        end
      end

      # 以前コメントした人たちにも通知
      if true
        member_users.each do |user|
          if user.email_valid? || Rails.env.test?
            UserMailer.question_other_message(user, self).deliver_later
          end
          user.notifications.create!(question_message: self)
        end
      end

      SlackAgent.message_send(key: "問題コメント", body: [body, question.page_url].join("\n"))
    end

    # 関係者
    def member_users
      users = question.message_users         # コメントした人たち
      users = users - [user]                 # コメントした本人はコメント内容を知っているので送信しない
      users = users - [question.user]        # 作者にはすでに送っているので送信しない
      users = users.uniq                     # 複数通知しないように
    end
  end
end
