module Fanta
  class LifetimeInfo
    include ApplicationMemoryRecord
    memory_record [
      {key: :lifetime_m10,  name: "10分", limit_seconds: 60 * 10, byoyomi: 3,  },
      {key: :lifetime_m5,   name: "5分",  limit_seconds: 60 *  5, byoyomi: 3,  },
      {key: :lifetime_m3,   name: "3分",  limit_seconds: 60 *  3, byoyomi: 3,  },
      {key: :lifetime_p10,  name: "+10秒", limit_seconds:      0, byoyomi: 10, },
      *if Rails.env.development?
         [
          {key: :lifetime_s0,     name: "0秒",      limit_seconds: 0, byoyomi: 0,  },
          {key: :lifetime_s3,     name: "3秒",      limit_seconds: 3, byoyomi: 0,  },
          {key: :lifetime_s3_p10, name: "3秒+10秒", limit_seconds: 3, byoyomi: 10, },
        ]
       end
    ]

    def as_json(options = {})
      super(options.merge(methods: [:name]))
    end
  end
end
