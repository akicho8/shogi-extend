#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

XyRecord.destroy_all
XyRuleInfo.redis.flushdb

XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 0.005, x_count: 0).best_update_info # => nil
XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 0.006, x_count: 0).best_update_info # => nil
XyRecord.create!(xy_rule_key: "xy_rule100t", entry_name: "x", spent_sec: 0.004, x_count: 0).best_update_info # => {:updated_spent_sec=>0.001}

