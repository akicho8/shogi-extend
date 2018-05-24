class LifetimeInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: :lifetime10_min,  name: "10分",       limit_seconds: 60 * 10, byoyomi: 0,  },
    {key: :lifetime5_min,   name: "5分",        limit_seconds: 60 *  5, byoyomi: 0,  },
    {key: :lifetime3_min,   name: "3分",        limit_seconds: 60 *  3, byoyomi: 0,  },
    {key: :lifetime3_sec,   name: "3秒",        limit_seconds:  1 *  3, byoyomi: 0,  },
    {key: :lifetime0_sec,   name: "0秒",        limit_seconds:  1 *  0, byoyomi: 0,  },
    {key: :lifetime10_kire, name: "3秒 + 10秒", limit_seconds:  1 *  3, byoyomi: 10, },
    {key: :lifetime30_kire, name: "3秒 + 30秒", limit_seconds:  1 *  3, byoyomi: 30, },
  ]
end
