# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Notification (emox_notifications as Emox::Notification)
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
# User.has_one :profile
#--------------------------------------------------------------------------------

# 問題にコメントしたときの通知
module Emox
  # rails r "tp User.first.notifications.create!(question_message: Emox::QuestionMessage.first)"
  # rails r "tp User.first.notifications.to_sql"
  class Notification < ApplicationRecord
    belongs_to :user, class_name: "::User"
    belongs_to :question_message

    after_create_commit do
      Emox::NotificationBroadcastJob.perform_later(self)
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
