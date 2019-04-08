class WinRangeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "格上", op: :>,  win_range: 0.0..0.5, rate_max: 0.5, },
    { key: "同格", op: :==, win_range: 0.3..0.7, rate_max: 0.6, },
    { key: "格下", op: :<,  win_range: 0.5..1.0, rate_max: 0.7, },
  ]
end
