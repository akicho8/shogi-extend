module Actb
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :sy_singleton, name: "シングルトン", display_p: true,  strategy_key: :sy_singleton, time_limit_sec: 10, description: "早押しクイズ形式"},
      { key: :sy_marathon,  name: "マラソン",     display_p: true,  strategy_key: :sy_marathon,  time_limit_sec: 60, description: "自分のペースで解いて先にゴールした方が勝ち (はじめての方向け)"},
      { key: :sy_hybrid,    name: "ハイブリッド", display_p: false, strategy_key: :sy_hybrid,    time_limit_sec: 60, description: "マラソンルールだけど相手が解いたら次に進んじゃう"},
    ]

    def self.default_key
      :sy_marathon
    end

    def redis_key
      [self.class.name.demodulize.underscore, :matching_user_ids, key].join("/")
    end
  end
end
