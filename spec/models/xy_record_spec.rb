# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xy record (xy_records as XyRecord)
#
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | name              | desc           | type        | opts        | refs                        | index |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | id                | ID             | integer(8)  | NOT NULL PK |                             |       |
# | colosseum_user_id | Colosseum user | integer(8)  |             | :user => Colosseum::User#id | A     |
# | entry_name        | Entry name     | string(255) | NOT NULL    |                             | C     |
# | summary           | Summary        | string(255) |             |                             |       |
# | xy_rule_key       | Xy rule key    | string(255) | NOT NULL    |                             | B     |
# | x_count           | X count        | integer(4)  | NOT NULL    |                             |       |
# | spent_sec         | Spent sec      | float(24)   | NOT NULL    |                             |       |
# | created_at        | 作成日時       | datetime    | NOT NULL    |                             |       |
# | updated_at        | 更新日時       | datetime    | NOT NULL    |                             |       |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe XyRecord, type: :model do
  it do
    XyRecord.destroy_all

    Timecop.freeze("2000-01-01") do
      XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "a", spent_sec: 1, x_count: 0)
      XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "b", spent_sec: 1, x_count: 0)
    end

    Timecop.freeze("2000-01-02") do
      XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "a", spent_sec: 2, x_count: 0)
      XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "a", spent_sec: 3, x_count: 0)
      XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "b", spent_sec: 2, x_count: 0)
      XyRecord.create!(xy_rule_key: "xy_rule1", entry_name: "b", spent_sec: 3, x_count: 0)

      XyRuleInfo.redis.flushdb
      XyRuleInfo[:xy_rule1].aggregate

      assert { build(xy_scope_key: "xy_scope_all",   entry_name_unique: "false") == [1, 1, 2, 2, 3, 3] }
      assert { build(xy_scope_key: "xy_scope_all",   entry_name_unique: "true")  == [1, 1]             }
      assert { build(xy_scope_key: "xy_scope_today", entry_name_unique: "false") == [2, 2, 3, 3]       }
      assert { build(xy_scope_key: "xy_scope_today", entry_name_unique: "true")  == [2, 2]             }
    end
  end

  def build(*args)
    v = XyRuleInfo[:xy_rule1].xy_records(*args)
    tp v
    v.collect { |e | e["spent_sec"] }
  end
end
