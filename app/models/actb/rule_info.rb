module Actb
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :marathon_rule,  name: "マラソン",     display_p: true,  time_limit_sec: 60, },
      { key: :singleton_rule, name: "シングルトン", display_p: true,  time_limit_sec: 10, },
      { key: :hybrid_rule,    name: "ハイブリッド", display_p: false, time_limit_sec: 60, },
    ]

    def redis_key
      [self.class.name.demodulize.underscore, :matching_user_ids, key].join("/")
    end
  end
end
