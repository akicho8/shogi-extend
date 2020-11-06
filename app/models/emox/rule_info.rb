# -*- compile-command: "rails r 'Emox::Rule.destroy_all; Emox::Rule.setup; tp Emox::Rule'" -*-

module Emox
  # rails r "tp Emox::RuleInfo.as_json"
  # rails r "puts Emox::RuleInfo.to_json"
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :fischer_m3_p5_rule, name: "フィッシャールール 3分 +5秒/手", initial_main_sec: 60*3, initial_read_sec:0, initial_extra_sec: 0, every_plus:5, },
    ]

    class << self
      def default_key
        :fischer_m3_p5_rule
      end
    end

    def redis_key
      [self.class.name.underscore, :matching_user_ids, key].join("/")
    end
  end
end
