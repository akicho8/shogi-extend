# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Mute info (mute_infos as MuteInfo)
#
# |----------------+-------------+------------+-------------+------------+-------|
# | name           | desc        | type       | opts        | refs       | index |
# |----------------+-------------+------------+-------------+------------+-------|
# | id             | ID          | integer(8) | NOT NULL PK |            |       |
# | user_id        | User        | integer(8) | NOT NULL    | => User#id | A! B  |
# | target_user_id | Target user | integer(8) | NOT NULL    |            | A! C  |
# | created_at     | 作成日時    | datetime   | NOT NULL    |            |       |
# | updated_at     | 更新日時    | datetime   | NOT NULL    |            |       |
# |----------------+-------------+------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

class MuteInfo < ApplicationRecord
  belongs_to :user
  belongs_to :target_user, class_name: "::User"

  with_options presence: true do
    validates :user_id
    validates :target_user_id
  end

  with_options allow_blank: true do
    validates :user_id, uniqueness: { scope: :target_user_id }
  end
end
