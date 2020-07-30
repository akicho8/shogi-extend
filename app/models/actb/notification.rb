# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Notification (actb_notifications as Actb::Notification)
#
# |---------------------+------------------+-------------+-------------+------+-------|
# | name                | desc             | type        | opts        | refs | index |
# |---------------------+------------------+-------------+-------------+------+-------|
# | id                  | ID               | integer(8)  | NOT NULL PK |      |       |
# | to_user_id          | To user          | integer(8)  | NOT NULL    |      | A     |
# | from_user_id        | From user        | integer(8)  |             |      | B     |
# | question_id         | Question         | integer(8)  |             |      | C     |
# | question_message_id | Question message | integer(8)  |             |      | D     |
# | title               | タイトル         | string(255) |             |      |       |
# | body                | 内容             | string(512) |             |      |       |
# | opened_at           | Opened at        | datetime    |             |      |       |
# | created_at          | 作成日時         | datetime    | NOT NULL    |      |       |
# | updated_at          | 更新日時         | datetime    | NOT NULL    |      |       |
# |---------------------+------------------+-------------+-------------+------+-------|

# create_table :actb_notifications, force: true do |t|
#   # t.string :key,                                                                  null: false, index: true
#   t.belongs_to :to_user,          foreign_key: {to_table: :users},                  null: true,  comment: "送信先"
#   t.belongs_to :from_user,        foreign_key: {to_table: :users},                  null: false, comment: "送信元"
#   t.belongs_to :question,         foreign_key: {to_table: :actb_questions},         null: false, comment: "問題"
#   t.belongs_to :question_message, foreign_key: {to_table: :actb_question_messages}, null: false, comment: "問題コメ"
#   t.string     :title, limit: 256,                                                  null: false, comment: "タイトル"
#   t.string     :body,  limit: 512,                                                  null: false, comment: "本文"
#   t.datetime   :opened_at,                                                          null: false, comment: "開封日時"
#   t.timestamps
# end

module Actb
  # rails r "tp User.first.received_notifications.create!(question_message: Actb::QuestionMessage.first)"
  # rails r "tp User.first.received_notifications.to_sql"
  class Notification < ApplicationRecord
    belongs_to :from_user, class_name: "::User", required: false
    belongs_to :to_user, class_name: "::User"

    belongs_to :question, required: false
    belongs_to :question_message, required: false

    before_validation do
      if Rails.env.development? || Rails.env.test?
        self.title ||= "(title)"
        self.body ||= "(body)"
      end

      if question_message
        self.question ||= question_message.question
      end
      if question
        self.to_user ||= question.user
      end
    end

    with_options presence: true do
      validates :to_user_id
    end

    after_create_commit do
      Actb::NotificationBroadcastJob.perform_later(self)
    end

    def as_json_type11
      as_json({
          only: [:id, :title, :body, :created_at, :opened_at],
          include: {
            to_user: {
              only: [:id],
            },
            question_message: {
              only: [:body],
              include: {
                question: {
                  only: [:id, :title],
                  include: {
                    user: {
                      only: [:id, :name],
                      # methods: [:avatar_path],
                    },
                  },
                },
                user: {
                  only: [:id, :name],
                  methods: [:avatar_path],
                },
              },
            },
          },
        })
    end
  end
end
