# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Ban crawl request (swars_ban_crawl_requests as Swars::BanCrawlRequest)
#
# |------------+----------+------------+-------------+------------+-------|
# | name       | desc     | type       | opts        | refs       | index |
# |------------+----------+------------+-------------+------------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |            |       |
# | user_id    | User     | integer(8) | NOT NULL    | => User#id | A     |
# | created_at | 作成日時 | datetime   | NOT NULL    |            |       |
# | updated_at | 更新日時 | datetime   | NOT NULL    |            |       |
# |------------+----------+------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

module Swars
  RSpec.describe BanCrawlRequest, type: :model, swars_spec: true do
    it "リレーションが正しい" do
      user = User.create!
      ban_crawl_request = user.ban_crawl_requests.create!
      assert { ban_crawl_request.user == user }
      assert { user.ban_crawl_requests == [ban_crawl_request] }
    end
  end
end
