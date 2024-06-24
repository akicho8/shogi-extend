module Swars
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :ten_min,   name: "10分", long_name: "10分切れ負け", swars_magic_key: "",   csa_time_limit: "00:10+00", life_time: 10.minutes, real_life_time: nil, ittezume_jirasi_sec: 1.0.minutes, kangaesugi_sec: 2.5.minutes, kangaesugi_like_houti_sec: 3.minutes, toryo_houti_sec: 1.minutes, taisekimati_sec: 5.minutes, related_time_p: true,  resignation_limit: 3.minutes, most_min_turn_max_limit: 35, },
      { key: :three_min, name: "3分",  long_name: "3分切れ負け",  swars_magic_key: "sb", csa_time_limit: "00:03+00", life_time: 3.minutes,  real_life_time: nil, ittezume_jirasi_sec: 45.seconds,  kangaesugi_sec: 30.seconds,  kangaesugi_like_houti_sec: 1.minutes, toryo_houti_sec: 1.minutes, taisekimati_sec: 2.minutes, related_time_p: true,  resignation_limit: 1.minutes, most_min_turn_max_limit: 35, },
      { key: :ten_sec,   name: "10秒", long_name: "1手10秒",      swars_magic_key: "s1", csa_time_limit: "00:00+10", life_time: 1.hour,     real_life_time: 0,   ittezume_jirasi_sec: nil,         kangaesugi_sec: nil,         kangaesugi_like_houti_sec: nil,       toryo_houti_sec: nil,       taisekimati_sec: nil,       related_time_p: false, resignation_limit: 1.minutes, most_min_turn_max_limit: 35, }, # 内部的には1時間設定になっているため変更してはいけない
    ]

    class << self
      def lookup(v)
        if v.kind_of?(String)
          v = StringToolkit.hankaku_format(v)
        end
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= inject({}) do |a, e|
          a.merge({
              e.swars_magic_key => e,
              e.name            => e,
              e.long_name       => e,
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
end

if $0 == __FILE__
  p Swars::RuleInfo[""].name
end
