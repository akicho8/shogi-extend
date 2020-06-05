# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Profile (profiles as Profile)
#
# |------------------------+------------------------+-------------+-------------+------------+-------|
# | name                   | desc                   | type        | opts        | refs       | index |
# |------------------------+------------------------+-------------+-------------+------------+-------|
# | id                     | ID                     | integer(8)  | NOT NULL PK |            |       |
# | user_id                | User                   | integer(8)  | NOT NULL    | => User#id | A!    |
# | begin_greeting_message | Begin greeting message | string(255) | NOT NULL    |            |       |
# | end_greeting_message   | End greeting message   | string(255) | NOT NULL    |            |       |
# | created_at             | 作成日時               | datetime    | NOT NULL    |            |       |
# | updated_at             | 更新日時               | datetime    | NOT NULL    |            |       |
# |------------------------+------------------------+-------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

class Profile < ApplicationRecord
  belongs_to :user

  before_validation do
    self.begin_greeting_message = begin_greeting_message.presence || "よろしくお願いします"
    self.end_greeting_message   = end_greeting_message.presence || "ありがとうございました"
  end

  with_options presence: true do
    validates :begin_greeting_message
    validates :end_greeting_message
  end
end
