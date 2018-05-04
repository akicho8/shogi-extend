class LifetimeInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: :lifetime15_min, name: "15分", limit_seconds: 60 * 15, },
    {key: :lifetime10_min, name: "10分", limit_seconds: 60 * 10, },
    {key: :lifetime5_min,  name: "5分",  limit_seconds: 60 *  5, },
    {key: :lifetime3_min,  name: "3分",  limit_seconds: 60 *  3, },
    {key: :lifetime3_sec,  name: "3秒",  limit_seconds:  1 *  3, },
    {key: :lifetime0_sec,  name: "0秒",  limit_seconds:  1 *  0, },
  ]
end
