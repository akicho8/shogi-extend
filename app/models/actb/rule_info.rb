module Actb
  class RuleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :marathon_rule,  name: "マラソン",     display_p: true,  time_limit_sec: 60, description: "自分のペースで解いて先にゴールした方が勝ち (はじめての方向け)"},
      { key: :singleton_rule, name: "シングルトン", display_p: true,  time_limit_sec: 10, description: "早押しクイズ形式"},
      { key: :hybrid_rule,    name: "ハイブリッド", display_p: false, time_limit_sec: 60, description: "マラソンルールだけど相手が解いたら次に進んじゃう"},
    ]

    def redis_key
      [self.class.name.demodulize.underscore, :matching_user_ids, key].join("/")
    end
  end
end
