# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Notification (actb_notifications as Actb::Notification)
#
# |---------------------+------------------+------------+-------------+--------------+-------|
# | name                | desc             | type       | opts        | refs         | index |
# |---------------------+------------------+------------+-------------+--------------+-------|
# | id                  | ID               | integer(8) | NOT NULL PK |              |       |
# | question_message_id | Question message | integer(8) | NOT NULL    |              | A     |
# | user_id             | User             | integer(8) | NOT NULL    | => ::User#id | B     |
# | opened_at           | Opened at        | datetime   |             |              |       |
# | created_at          | 作成日時         | datetime   | NOT NULL    |              |       |
# | updated_at          | 更新日時         | datetime   | NOT NULL    |              |       |
# |---------------------+------------------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

# 問題にコメントしたときの通知
module Actb
  # rails r "tp User.first.notifications.create!(question_message: Actb::QuestionMessage.first)"
  # rails r "tp User.first.notifications.to_sql"
  class Notification < ApplicationRecord
    belongs_to :user, class_name: "::User"
    belongs_to :question_message

    after_create_commit do
      Actb::NotificationBroadcastJob.perform_later(self)
    end

    def as_json_type11
      as_json({
          only: [:id, :opened_at],
          include: {
            user: {
              only: [:id],
            },
            question_message: {
              only: [:body, :created_at],
              include: {
                question: {
                  only: [:id, :title],
                  include: {
                    user: {
                      only: [:id, :name],
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
