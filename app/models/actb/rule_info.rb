module Actb
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :marathon_rule,  name: "マラソン",     },
      { key: :singleton_rule, name: "シングルトン", },
    ]

    def redis_key
      [self.class.name.demodulize.underscore, :matching_list, key].join("/")
    end
  end
end
