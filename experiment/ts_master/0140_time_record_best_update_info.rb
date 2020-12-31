require "./setup"

TimeRecord.destroy_all
RuleInfo.redis.flushdb

TimeRecord.create!(rule_key: "rule_mate3_type1", entry_name: "x", spent_sec: 0.005, x_count: 0).best_update_info # => nil
TimeRecord.create!(rule_key: "rule_mate3_type1", entry_name: "x", spent_sec: 0.006, x_count: 0).best_update_info # => nil
TimeRecord.create!(rule_key: "rule_mate3_type1", entry_name: "x", spent_sec: 0.004, x_count: 0).best_update_info # => {:updated_spent_sec=>0.001}

