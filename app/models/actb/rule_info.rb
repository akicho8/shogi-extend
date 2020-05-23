module Actb
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :rule_key1, name: "マラソン",     },
      { key: :rule_key2, name: "シングルトン", },
    ]

    def redis_key
      [self.class.name.demodulize.underscore, :matching_list, key].join("/")
    end
  end
end
