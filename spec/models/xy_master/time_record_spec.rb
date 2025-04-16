# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Time record (xy_master_time_records as XyMaster::TimeRecord)
#
# |------------+------------+-------------+-------------+--------------+-------|
# | name       | desc       | type        | opts        | refs         | index |
# |------------+------------+-------------+-------------+--------------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User       | integer(8)  |             | => ::User#id | A     |
# | rule_id    | Rule       | integer(8)  | NOT NULL    |              | B     |
# | entry_name | Entry name | string(255) | NOT NULL    |              | C     |
# | summary    | Summary    | string(255) |             |              |       |
# | x_count    | X count    | integer(4)  | NOT NULL    |              |       |
# | spent_sec  | Spent sec  | float(24)   | NOT NULL    |              |       |
# | created_at | 作成日時   | datetime    | NOT NULL    |              |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |              |       |
# |------------+------------+-------------+-------------+--------------+-------|
#
# - Remarks ---------------------------------------------------------------------
# User.has_one :profile
# -------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe XyMaster::TimeRecord, type: :model do
  before do
    XyMaster.destroy_all
    XyMaster::Rule.setup
    XyMaster::RuleInfo.redis.flushdb
  end

  it "記録と順位が正しい" do
    Timecop.freeze("2000-01-01") do
      XyMaster::TimeRecord.create!(rule_key: "rule100", entry_name: "a", spent_sec: 1, x_count: 0)
      XyMaster::TimeRecord.create!(rule_key: "rule100", entry_name: "b", spent_sec: 1, x_count: 0)
    end

    Timecop.freeze("2000-01-02") do
      XyMaster::TimeRecord.create!(rule_key: "rule100", entry_name: "a", spent_sec: 2, x_count: 0)
      XyMaster::TimeRecord.create!(rule_key: "rule100", entry_name: "a", spent_sec: 3, x_count: 0)
      XyMaster::TimeRecord.create!(rule_key: "rule100", entry_name: "b", spent_sec: 2, x_count: 0)
      XyMaster::TimeRecord.create!(rule_key: "rule100", entry_name: "b", spent_sec: 3, x_count: 0)

      XyMaster::RuleInfo.redis.flushdb
      XyMaster::RuleInfo[:rule100].aggregate

      assert { build(scope_key: "scope_all",   entry_name_uniq_p: "false") == [1, 1, 2, 2, 3, 3] }
      assert { build(scope_key: "scope_all",   entry_name_uniq_p: "true")  == [1, 1]             }
      assert { build(scope_key: "scope_today", entry_name_uniq_p: "false") == [2, 2, 3, 3]       }
      assert { build(scope_key: "scope_today", entry_name_uniq_p: "true")  == [2, 2]             }
    end
  end

  it "ユニークの場合は一番良い結果を更新してないと登録しない点に注意" do
    XyMaster::TimeRecord.create!(rule_key: "rule100t", entry_name: "x", spent_sec: 10, x_count: 0) # 登録する
    XyMaster::TimeRecord.create!(rule_key: "rule100t", entry_name: "x", spent_sec: 20, x_count: 0) # 以降登録しない
    XyMaster::TimeRecord.create!(rule_key: "rule100t", entry_name: "x", spent_sec: 30, x_count: 0)
    XyMaster::TimeRecord.create!(rule_key: "rule100t", entry_name: "x", spent_sec: 40, x_count: 0)
    XyMaster::RuleInfo.rebuild
    r = XyMaster::TimeRecord.last
    assert { r.rank(scope_key: "scope_all", entry_name_uniq_p: "true") == 2 } # 全体だと40は2位
  end

  it "自己ベスト更新" do
    assert { XyMaster::TimeRecord.create!(rule_key: "rule100t", entry_name: "x", spent_sec: 100.333, x_count: 0).best_update_info == nil                       }
    assert { XyMaster::TimeRecord.create!(rule_key: "rule100t", entry_name: "x", spent_sec: 100.334, x_count: 0).best_update_info == nil                       }
    assert { XyMaster::TimeRecord.create!(rule_key: "rule100t", entry_name: "x", spent_sec: 100.332, x_count: 0).best_update_info == { updated_spent_sec: 0.001 }  }
  end

  def build(*args)
    v = XyMaster::RuleInfo[:rule100].time_records(*args)
    if ENV["VERBOSE"]
      tp v
    end
    v.collect { |e | e["spent_sec"] }
  end

  it "app_logging" do
    record = XyMaster::TimeRecord.create!(rule_key: "rule100", entry_name: "a", spent_sec: 1, x_count: 0)
    record.app_logging
  end
end
