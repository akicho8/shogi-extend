class QuickScript::Swars::TacticStatScript
  class PeriodInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :day7,  name: "1週間", period_second: 7.day,  },
      { key: :day30, name: "1ヶ月", period_second: 30.day, },
      { key: :day60, name: "2ヶ月", period_second: 60.day, },
    ]
  end
end
