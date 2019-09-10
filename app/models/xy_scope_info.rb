class XyScopeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "xy_scope_all",   name: "全体", key_method: :all_table_key,   table_key_for: -> xy_record, xy_rule_info { xy_rule_info.all_table_key                        } },
    { key: "xy_scope_today", name: "今日", key_method: :today_table_key, table_key_for: -> xy_record, xy_rule_info { xy_rule_info.time_table_key(xy_record.created_at) } },
  ]
end
