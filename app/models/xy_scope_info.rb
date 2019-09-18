class XyScopeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "xy_scope_all",   name: "総合", key_method: :all_table_key,   date_visible: true,  table_key_for: -> xy_record, xy_rule_info { xy_rule_info.all_table_key                        }, xy_record_scope: -> scope { scope }},
    { key: "xy_scope_today", name: "今日", key_method: :today_table_key, date_visible: false, table_key_for: -> xy_record, xy_rule_info { xy_rule_info.time_table_key(xy_record.created_at) }, xy_record_scope: -> scope { scope.where(created_at: Time.current.midnight...Time.current.tomorrow.midnight) }},
  ]
end
