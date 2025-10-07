module Swars
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :ten_min,   name: "10分", long_name: "10分切れ負け", sw_side_key: "",   csa_time_limit: "00:10+00", life_time: 10.minutes, real_life_time: nil, ittezume_jirasi_sec: 1.0.minutes, kangaesugi_sec: 2.5.minutes, kangaesugi_like_houti_sec: 3.minutes, toryo_houti_sec: 1.minutes, taisekimati_sec: 5.minutes, related_time_p: true,  },
      { key: :three_min, name: "3分",  long_name: "3分切れ負け",  sw_side_key: "sb", csa_time_limit: "00:03+00", life_time: 3.minutes,  real_life_time: nil, ittezume_jirasi_sec: 45.seconds,  kangaesugi_sec: 30.seconds,  kangaesugi_like_houti_sec: 1.minutes, toryo_houti_sec: 1.minutes, taisekimati_sec: 2.minutes, related_time_p: true,  },
      { key: :ten_sec,   name: "10秒", long_name: "1手10秒",      sw_side_key: "s1", csa_time_limit: "00:00+10", life_time: 1.hour,     real_life_time: 0,   ittezume_jirasi_sec: nil,         kangaesugi_sec: nil,         kangaesugi_like_houti_sec: nil,       toryo_houti_sec: nil,       taisekimati_sec: nil,       related_time_p: false, }, # 内部的には1時間設定になっているため変更してはいけない
      { key: :custom,    name: "カスタム", long_name: "カスタム", sw_side_key: "sf", csa_time_limit: nil,        life_time: nil,        real_life_time: nil, ittezume_jirasi_sec: nil,         kangaesugi_sec: nil,         kangaesugi_like_houti_sec: nil,       toryo_houti_sec: nil,       taisekimati_sec: nil,       related_time_p: false, },
    ]

    prepend AliasMod

    class << self
      def key_cast(v)
        if v.kind_of?(String)
          v = StringSupport.hankaku_format(v)
        end
        v
      end
    end

    def short_name
      name
    end

    def real_life_time
      super || life_time
    end

    def secondary_key
      [sw_side_key, name, long_name]
    end
  end
end
