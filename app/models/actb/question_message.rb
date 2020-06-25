# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Question message (actb_question_messages as Actb::QuestionMessage)
#
# |-------------+----------+-------------+-------------+--------------+-------|
# | name        | desc     | type        | opts        | refs         | index |
# |-------------+----------+-------------+-------------+--------------+-------|
# | id          | ID       | integer(8)  | NOT NULL PK |              |       |
# | user_id     | User     | integer(8)  | NOT NULL    | => ::User#id | A     |
# | question_id | Question | integer(8)  | NOT NULL    |              | B     |
# | body        | 内容     | string(140) | NOT NULL    |              |       |
# | created_at  | 作成日時 | datetime    | NOT NULL    |              |       |
# | updated_at  | 更新日時 | datetime    | NOT NULL    |              |       |
# |-------------+----------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

module Actb
  class QuestionMessage < ApplicationRecord
    include MessageShared

    belongs_to :question, counter_cache: :messages_count

    def full_url
      Rails.application.routes.url_helpers.url_for([:training, {only_path: false, question_id: question.id}])
    end

    after_create_commit do
      Actb::QuestionMessageBroadcastJob.perform_later(self)

      UserMailer.question_message_created(self).deliver_later

      SlackAgent.message_send(key: "問題コメント", body: [body, question.full_url].join(" "))
    end
  end
end
