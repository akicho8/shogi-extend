module Fanta
  class CpuBrainInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :level1, name: "ルール棋覚えたての", time_limit: nil,     depth_max_range: nil,  legal_only: false, mate_danger_check: false, }, # ランダムで王手でも逃げない
      { key: :level2, name: "あきれるほど弱い",   time_limit: nil,     depth_max_range: nil,  legal_only: false, mate_danger_check: true,  }, # ランダムだけど王手のときは逃げる
      { key: :level3, name: "ありえないほど弱い", time_limit: nil,     depth_max_range: nil,  legal_only: true,  mate_danger_check: true,  }, # 合法手のランダム
      { key: :level4, name: "めちゃくちゃ弱い",   time_limit: nil,     depth_max_range: 0..0, legal_only: true,  mate_danger_check: true,  }, # 最初の合法手リストを最善手順に並べたもの
      { key: :level5, name: "かなり弱い",         time_limit: [10],    depth_max_range: 1..1, legal_only: true,  mate_danger_check: true,  }, # 相手の手を考慮する
      { key: :level6, name: "弱い",               time_limit: [15],    depth_max_range: 2..2, legal_only: true,  mate_danger_check: true,  }, # できれば3手先まで読む
      { key: :level7, name: "最大1分考える",      time_limit: [60],    depth_max_range: 2..2, legal_only: true,  mate_danger_check: true,  }, # 長考して3手先まで読む
      { key: :level8, name: "3分考える",          time_limit: [60*3],  depth_max_range: 2..5, legal_only: true,  mate_danger_check: true,  }, # 長考して最大6手先まで読む
      { key: :level9, name: "30分考える",         time_limit: [60*30], depth_max_range: 2..5, legal_only: true,  mate_danger_check: true,  }, # 長考して最大6手先まで読む
    ]
  end
end
