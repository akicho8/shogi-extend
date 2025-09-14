module XyMaster
  class ScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "scope_today",      name: "本日", key_method: :table_key_for_today,      date_visible: false, table_key_for: -> time_record, rule_info { rule_info.ymd_table_key_for_time(time_record.created_at) }, time_record_scope: -> scope { scope.where(created_at: Time.current.all_day)              } },
      { key: "scope_yesterday",  name: "昨日", key_method: :table_key_for_yesterday,  date_visible: false, table_key_for: -> time_record, rule_info { rule_info.ymd_table_key_for_time(time_record.created_at) }, time_record_scope: -> scope { scope.where(created_at: Time.current.yesterday.all_day)    } },
      { key: "scope_month",      name: "今月", key_method: :table_key_for_month,      date_visible: false, table_key_for: -> time_record, rule_info { rule_info.ym_table_key_for_time(time_record.created_at)  }, time_record_scope: -> scope { scope.where(created_at: Time.current.all_month)            } },
      { key: "scope_prev_month", name: "先月", key_method: :table_key_for_prev_month, date_visible: false, table_key_for: -> time_record, rule_info { rule_info.ym_table_key_for_time(time_record.created_at)  }, time_record_scope: -> scope { scope.where(created_at: Time.current.prev_month.all_month) } },
      { key: "scope_all",        name: "全体", key_method: :table_key_for_all,        date_visible: true,  table_key_for: -> time_record, rule_info { rule_info.table_key_for_all                              }, time_record_scope: -> scope { scope                                                      } },
    ]
  end
end
