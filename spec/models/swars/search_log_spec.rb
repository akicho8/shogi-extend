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
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Swars::SearchLog, type: :model, swars_spec: true do
  it "古いレコードを削除する" do
    user = Swars::User.create!
    user.search_logs.create!
    assert { Swars::SearchLog.count == 1 }
    Timecop.freeze(1.seconds.from_now) do
      Swars::SearchLog.old_only(0).cleaner(execute: true).call
    end
    assert { Swars::SearchLog.count == 0 }
  end

  it "VIPユーザーを除いて最近検索したユーザーIDsを取得する" do
    user = Swars::User.create!
    user.search_logs.create!
    assert { Swars::SearchLog.momentum_user_ids(period: 0.days, at_least: 1) == [user.id] }
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::SearchLog
# >> 1999-12-31T15:00:01.000Z pid=85696 tid=1w7s INFO: Swars::Sidekiq 7.1.6 connecting to Swars::Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >>   古いレコードを削除する
# >>   最近検索したユーザーIDsを取得する
# >>
# >> Swars::Top 2 slowest examples (0.41428 seconds, 16.2% of total time):
# >>   Swars::SearchLog 古いレコードを削除する
# >>     0.34404 seconds -:23
# >>   Swars::SearchLog 最近検索したユーザーIDsを取得する
# >>     0.07025 seconds -:33
# >>
# >> Swars::Finished in 2.56 seconds (files took 2.21 seconds to load)
# >> 2 examples, 0 failures
# >>
