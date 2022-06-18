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
# | description | 自己紹介          | string(512) | NOT NULL    |            |       |
# | twitter_key | Twitterアカウント | string(255) | NOT NULL    |            |       |
# | created_at  | 作成日時          | datetime    | NOT NULL    |            |       |
# | updated_at  | 更新日時          | datetime    | NOT NULL    |            |       |
# |-------------+-------------------+-------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Profile, type: :model do
  let!(:user1) { User.create! }

  it "delegateしているのでuserから使える" do
    assert { user1.description }
    assert { user1.twitter_key }
  end

  describe "Twitterアカウント" do
    it "空だった" do
      user1.profile.update!(twitter_key: "")
      assert { user1.profile.twitter_key == "" }
    end

    describe "Twitterアカウントが何のことかわかってない人対策" do
      it "URLを入力された" do
        user1.profile.update!(twitter_key: "https//example.com/foo")
        assert { user1.profile.twitter_key == "foo" }
      end
      it "リプする形式で入力された" do
        user1.profile.update!(twitter_key: "@foo")
        assert { user1.profile.twitter_key == "foo" }
      end
    end
  end
end
