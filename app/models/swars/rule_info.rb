# short_leave_alone: 放置負け判定

module Swars
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      {key: :ten_min,   name: "10分", long_name: "10分切れ負け", swars_real_key: "",   csa_time_limit: "00:10+00", life_time: 10.minutes, real_life_time: nil, teasing_limit: 1.0.minutes, short_leave_alone: 2.5.minutes,  long_leave_alone: 3.minutes, related_time_p: true,  resignation_limit: 3.minutes, most_min_turn_max_limit: 35,  },
      {key: :three_min, name: "3分",  long_name: "3分切れ負け",  swars_real_key: "sb", csa_time_limit: "00:03+00", life_time: 3.minutes,  real_life_time: nil, teasing_limit: 45.seconds,  short_leave_alone: 30.seconds,   long_leave_alone: 1.minutes, related_time_p: true,  resignation_limit: 1.minutes, most_min_turn_max_limit: 35,  },
      {key: :ten_sec,   name: "10秒", long_name: "1手10秒",      swars_real_key: "s1", csa_time_limit: "00:00+10", life_time: 1.hour,     real_life_time: 0,   teasing_limit: nil,         short_leave_alone: nil,          long_leave_alone: nil,       related_time_p: false, resignation_limit: 1.minutes, most_min_turn_max_limit: 35,  }, # 内部的には1時間設定になっているため変更してはいけない
    ]

    class << self
      def lookup(v)
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= inject({}) do |a, e|
          a.merge({
                    e.swars_real_key => e,
                    e.name           => e,
                    e.long_name      => e,
                  })
        end
      end
    end

    def short_name
      name
    end

    def real_life_time
      super || life_time
    end
  end

  if $0 == __FILE__
    tp RuleInfo[""]
    # |------|
    # | 10分 |
    # |------|
  end
end
