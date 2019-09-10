class XyScopeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "xy_scope_all",   name: "全体", key_method: :all_inside_key,   },
    { key: "xy_scope_today", name: "本日", key_method: :today_inside_key, },
  ]

  def inside_key(xy_record, xy_rule_info)
    if key == :xy_scope_all
      xy_rule_info.all_inside_key
    else
      xy_rule_info.date_inside_key(xy_record.created_at)
    end
  end
end
