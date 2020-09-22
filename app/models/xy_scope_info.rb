class XyScopeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "xy_scope_today", name: "本日", key_method: :table_key_for_today, date_visible: false, table_key_for: -> xy_record, xy_rule_info { xy_rule_info.ymd_table_key_for_time(xy_record.created_at) }, xy_record_scope: -> scope { scope.where(created_at: Time.current.midnight...Time.current.tomorrow.midnight)                       }},
    { key: "xy_scope_month", name: "今月", key_method: :table_key_for_month, date_visible: false, table_key_for: -> xy_record, xy_rule_info { xy_rule_info.ym_table_key_for_time(xy_record.created_at)  }, xy_record_scope: -> scope { scope.where(created_at: Time.current.beginning_of_month...Time.current.beginning_of_month.next_month) }},
    { key: "xy_scope_all",   name: "全体", key_method: :table_key_for_all,   date_visible: true,  table_key_for: -> xy_record, xy_rule_info { xy_rule_info.table_key_for_all                            }, xy_record_scope: -> scope { scope                                                                                                 }},
  ]
end
