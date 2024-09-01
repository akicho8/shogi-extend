class QuickScript::Swars::TacticStatScript
  class UaInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :mobile,  chart_bar_max: 20, max_width: "", aspect_ratio: nil, },
      { key: :desktop, chart_bar_max: 50, max_width: "", aspect_ratio: 3.5, },
    ]
  end
end
