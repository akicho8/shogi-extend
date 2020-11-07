# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xy record (xy_records as XyRecord)
#
# |-------------+-------------+-------------+-------------+--------------+-------|
# | name        | desc        | type        | opts        | refs         | index |
# |-------------+-------------+-------------+-------------+--------------+-------|
# | id          | ID          | integer(8)  | NOT NULL PK |              |       |
# | user_id     | User        | integer(8)  |             | => ::User#id | A     |
# | entry_name  | Entry name  | string(255) | NOT NULL    |              | B     |
# | summary     | Summary     | string(255) |             |              |       |
# | xy_rule_key | Xy rule key | string(255) | NOT NULL    |              | C     |
# | x_count     | X count     | integer(4)  | NOT NULL    |              |       |
# | spent_sec   | Spent sec   | float(24)   | NOT NULL    |              |       |
# | created_at  | 作成日時    | datetime    | NOT NULL    |              |       |
# | updated_at  | 更新日時    | datetime    | NOT NULL    |              |       |
# |-------------+-------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe XyRecord, type: :model do
  before do
    XyRecord.destroy_all
    XyRuleInfo.redis.flushdb
  end

  it "記録と順位が正しい" do
    Timecop.freeze("2000-01-01") do
      XyRecord.create!(xy_rule_key: "xy_rule100", entry_name: "a", spent_sec: 1, x_count: 0)
      XyRecord.create!(xy_rule_key: "xy_rule100", entry_name: "b", spent_sec: 1, x_count: 0)
    end

    Timecop.freeze("2000-01-02") do
      XyRecord.create!(xy_rule_key: "xy_rule100", entry_name: "a", spent_sec: 2, x_count: 0)
      XyRecord.create!(xy_rule_key: "xy_rule100", entry_name: "a", spent_sec: 3, x_count: 0)
      XyRecord.create!(xy_rule_key: "xy_rule100", entry_name: "b", spent_sec: 2, x_count: 0)
      XyRecord.create!(xy_rule_key: "xy_rule100", entry_name: "b", spent_sec: 3, x_count: 0)

      XyRuleInfo.redis.flushdb
      XyRuleInfo[:xy_rule100].aggregate

      assert { build(xy_scope_key: "xy_scope_all",   entry_name_unique: "false") == [1, 1, 2, 2, 3, 3] }
      assert { build(xy_scope_key: "xy_scope_all",   entry_name_unique: "true")  == [1, 1]             }
      assert { build(xy_scope_key: "xy_scope_today", entry_name_unique: "false") == [2, 2, 3, 3]       }
      assert { build(xy_scope_key: "xy_scope_today", entry_name_unique: "true")  == [2, 2]             }
    end
  end

  it "ユニークの場合は一番良い結果を更新してないと登録しない点に注意" do
    XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 10, x_count: 0) # 登録する
    XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 20, x_count: 0) # 以降登録しない
    XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 30, x_count: 0)
    XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 40, x_count: 0)
    XyRuleInfo.rebuild
    r = XyRecord.last
    assert { r.rank(xy_scope_key: "xy_scope_all", entry_name_unique: "true") == 2 } # 全体だと40は2位
  end

  it "自己ベスト更新" do
    assert { XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 100.333, x_count: 0).best_update_info == nil                       }
    assert { XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 100.334, x_count: 0).best_update_info == nil                       }
    assert { XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 100.332, x_count: 0).best_update_info == {updated_spent_sec: 0.001 }  }
  end

  def build(*args)
    v = XyRuleInfo[:xy_rule100].xy_records(*args)
    if ENV["VERBOSE"]
      tp v
    end
    v.collect { |e | e["spent_sec"] }
  end
end
