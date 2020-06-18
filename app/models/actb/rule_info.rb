module Actb
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :marathon_rule,  name: "マラソン",     display_p: false, },
      { key: :singleton_rule, name: "シングルトン", display_p: true,  },
      { key: :hybrid_rule,    name: "ハイブリッド", display_p: false, },
    ]

    def redis_key
      [self.class.name.demodulize.underscore, :matching_ids, key].join("/")
    end
  end
end
