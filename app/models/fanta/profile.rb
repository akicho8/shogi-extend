# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Profileテーブル (fanta_profiles as Fanta::Profile)
#
# |------------------+----------------------+-------------+-------------+------+-------|
# | カラム名         | 意味                 | タイプ      | 属性        | 参照 | INDEX |
# |------------------+----------------------+-------------+-------------+------+-------|
# | id               | ID                   | integer(8)  | NOT NULL PK |      |       |
# | user_id          | User                 | integer(8)  | NOT NULL    |      | A     |
# | greeting_message | 対局開始時のあいさつ | text(65535) | NOT NULL    |      |       |
# | created_at       | 作成日時             | datetime    | NOT NULL    |      |       |
# | updated_at       | 更新日時             | datetime    | NOT NULL    |      |       |
# |------------------+----------------------+-------------+-------------+------+-------|

module Fanta
  class Profile < ApplicationRecord
    belongs_to :user

    before_validation do
      self.greeting_message = greeting_message.presence || "よろしくお願いします"
    end

    with_options presence: true do
      validates :greeting_message
    end
  end
end
