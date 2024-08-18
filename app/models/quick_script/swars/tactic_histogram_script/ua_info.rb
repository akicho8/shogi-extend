class QuickScript::Swars::TacticHistogramScript
  class UaInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :desktop, chart_bar_max: 50, max_width: "", aspect_ratio: 3.5, },
      { key: :mobile,  chart_bar_max: 20, max_width: "", aspect_ratio: nil, },
    ]
  end
end
