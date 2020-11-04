# -*- compile-command: "rails r 'Emox::Rule.destroy_all; Emox::Rule.setup; tp Emox::Rule'" -*-

module Emox
  # rails r "tp Emox::RuleInfo.as_json"
  # rails r "puts Emox::RuleInfo.to_json"
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :versus1_rule, name: "3分", time_limit_sec: nil, },
      { key: :versus2_rule, name: "5分", time_limit_sec: nil, },
    ]

    class << self
      def default_key
        :versus1_rule
      end

      def as_json(*)
        super({
            only: [
              :key,                  # PK
              :name,                 # ルール名
              :time_limit_sec,       # 問題が時間切れになるまでの秒数
            ],
          })
      end
    end

    def redis_key
      [self.class.name.underscore, :matching_user_ids, key].join("/")
    end
  end
end
