module Fanta
  class CpuBrainInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :level1, name: "あきれるほど弱い",   time_limit: nil, depth_max_range: nil,  legal_only: false, }, # ランダム
      { key: :level2, name: "ありえないほど弱い", time_limit: nil, depth_max_range: nil,  legal_only: true,  }, # 合法手のランダム
      { key: :level3, name: "めちゃくちゃ弱い",   time_limit: nil, depth_max_range: 0..0, legal_only: nil,   }, # 最初の合法手リストを最善手順に並べたもの
      { key: :level4, name: "かなり弱い",         time_limit:   3, depth_max_range: 0..9, legal_only: nil,   }, # 3秒まで深読みできる
      { key: :level5, name: "弱い",               time_limit:   5, depth_max_range: 0..9, legal_only: nil,   }, # 必ず相手の手を読む
    ]
  end
end
