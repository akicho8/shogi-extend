# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Profile (colosseum_profiles as Colosseum::Profile)
#
# |------------------------+----------------------+-------------+-------------+------+-------|
# | name                   | desc                 | type        | opts        | refs | index |
# |------------------------+----------------------+-------------+-------------+------+-------|
# | id                     | ID                   | integer(8)  | NOT NULL PK |      |       |
# | user_id                | User                 | integer(8)  | NOT NULL    |      | A!    |
# | begin_greeting_message | 対局開始時のあいさつ | string(255) | NOT NULL    |      |       |
# | end_greeting_message   | 対局終了時のあいさつ | string(255) | NOT NULL    |      |       |
# | created_at             | 作成日時             | datetime    | NOT NULL    |      |       |
# | updated_at             | 更新日時             | datetime    | NOT NULL    |      |       |
# |------------------------+----------------------+-------------+-------------+------+-------|

module Colosseum
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
end
