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

require 'rails_helper'

RSpec.describe Profile, type: :model do
  include ActbSupportMethods

  it do
    assert { user1.description }
    assert { user1.twitter_key }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.84416 seconds (files took 2.08 seconds to load)
# >> 1 example, 0 failures
# >> 
