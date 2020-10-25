# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Profile (profiles as Profile)
#
# |-------------+-------------------+-------------+-------------+------------+-------|
# | name        | desc              | type        | opts        | refs       | index |
# |-------------+-------------------+-------------+-------------+------------+-------|
# | id          | ID                | integer(8)  | NOT NULL PK |            |       |
# | user_id     | User              | integer(8)  | NOT NULL    | => User#id | A!    |
# | created_at  | 作成日時          | datetime    | NOT NULL    |            |       |
# | updated_at  | 更新日時          | datetime    | NOT NULL    |            |       |
# | description | 自己紹介          | string(512) | NOT NULL    |            |       |
# | twitter_key | Twitterアカウント | string(255) | NOT NULL    |            |       |
# |-------------+-------------------+-------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

class Profile < ApplicationRecord
  belongs_to :user

  before_validation do
    self.description = description.to_s.strip
    self.twitter_key = twitter_key.to_s.strip
  end

  with_options allow_blank: true do
    validates :description, length: { maximum: 512 }
  end
end
