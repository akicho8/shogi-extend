class QuickScript::Admin::AppLogSearchScript
  class PeriodInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :no_period,     name: "なし",       },
      { key: :last24h,       name: "直近24時間", },
      { key: :today_only,    name: "今日",       },
      { key: :tomorrow_only, name: "昨日",       },
      { key: :last3d,        name: "直近3日",    },
    ]
  end
end
