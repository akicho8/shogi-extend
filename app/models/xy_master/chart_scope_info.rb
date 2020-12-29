module XyMaster
  class ChartScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "chart_scope_recently", name: "最近", date_gteq: 30.days, },
      { key: "chart_scope_all",      name: "全体", date_gteq: nil,     },
    ]
  end
end
