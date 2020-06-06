# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Profile (profiles as Profile)
#
# |--------------+--------------+-------------+-------------+------------+-------|
# | name         | desc         | type        | opts        | refs       | index |
# |--------------+--------------+-------------+-------------+------------+-------|
# | id           | ID           | integer(8)  | NOT NULL PK |            |       |
# | user_id      | User         | integer(8)  | NOT NULL    | => User#id | A!    |
# | created_at   | 作成日時     | datetime    | NOT NULL    |            |       |
# | updated_at   | 更新日時     | datetime    | NOT NULL    |            |       |
# | introduction | Introduction | string(255) | NOT NULL    |            |       |
# |--------------+--------------+-------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

class Profile < ApplicationRecord
  belongs_to :user

  before_validation do
    self.introduction ||= ""
  end
end
