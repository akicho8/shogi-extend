# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Search log (swars_search_logs as Swars::SearchLog)
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
  RSpec.describe SearchLog, type: :model, swars_spec: true do
    it "古いレコードを削除する" do
      user = User.create!
      user.search_logs.create!
      assert { SearchLog.count == 1 }
      SearchLog.old_only(0.days).cleaner(execute: true).call
      assert { SearchLog.count == 0 }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::SearchLog
# >> 1999-12-31T15:00:00.000Z pid=97485 tid=1zqd INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >>   .old_only
# >> 
# >> Top 1 slowest examples (0.32399 seconds, 13.6% of total time):
# >>   Swars::SearchLog .old_only
# >>     0.32399 seconds -:5
# >> 
# >> Finished in 2.39 seconds (files took 1.99 seconds to load)
# >> 1 example, 0 failures
# >> 
