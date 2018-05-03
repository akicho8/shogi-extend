class MotijikanInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: :mode1, name: "10分", limit_seconds: 60 * 10, },
    {key: :mode2, name: "5分",  limit_seconds: 60 *  5, },
    {key: :mode3, name: "3分",  limit_seconds: 60 *  3, },
    {key: :mode4, name: "3秒",  limit_seconds:  1 *  3, },
    {key: :mode5, name: "0秒",  limit_seconds:  1 *  0, },
  ]
end
