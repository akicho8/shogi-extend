class QuickScript::Swars::TacticStatScript
  class PeriodInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :day1,  name: "1日",   period_second: 1.day,  form_available_envs: [                       :development, :test], },
      { key: :day3,  name: "3日",   period_second: 3.day,  form_available_envs: [                       :development, :test], },
      { key: :day7,  name: "1週間", period_second: 7.day,  form_available_envs: [:production, :staging, :development, :test], },
      { key: :day30, name: "1ヶ月", period_second: 30.day, form_available_envs: [:production, :staging, :development, :test], },
      { key: :day60, name: "2ヶ月", period_second: 60.day, form_available_envs: [:production, :staging, :development, :test], },
      { key: :year1, name: "1年",   period_second: 1.year, form_available_envs: [                       :development, :test], },
    ]
  end
end
