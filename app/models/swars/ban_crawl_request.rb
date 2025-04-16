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

module Swars
  class BanCrawlRequest < ApplicationRecord
    belongs_to :user
  end
end
