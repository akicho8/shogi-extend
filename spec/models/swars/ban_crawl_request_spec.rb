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
# - Remarks ---------------------------------------------------------------------
# User.has_one :profile
# -------------------------------------------------------------------------------

# == Swars::Schema Swars::Information ==
#
# Swars::Ban crawl request (swars_ban_crawl_requests as Swars::BanCrawlRequest)
#
# |------------+----------+------------+-------------+------------+-------|
# | name       | desc     | type       | opts        | refs       | index |
# |------------+----------+------------+-------------+------------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |            |       |
# | user_id    | Swars::User     | integer(8) | NOT NULL    | => Swars::User#id | A     |
# | created_at | 作成日時 | datetime   | NOT NULL    |            |       |
# | updated_at | 更新日時 | datetime   | NOT NULL    |            |       |
# |------------+----------+------------+-------------+------------+-------|
#
#- Swars::Remarks ----------------------------------------------------------------------
# Swars::User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Swars::BanCrawlRequest, type: :model, swars_spec: true do
  it "リレーションが正しい" do
    user = Swars::User.create!
    ban_crawl_request = user.ban_crawl_requests.create!
    assert { ban_crawl_request.user == user }
    assert { user.ban_crawl_requests == [ban_crawl_request] }
  end
end
