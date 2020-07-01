class CpuBrainInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :level1, name: "ルール覚えたての",    },
    { key: :level2, name: "あきれるほど弱い",    },
    { key: :level3, name: "ありえないほど弱い",  },
    { key: :level4, name: "めちゃくちゃ弱い",    },
    { key: :level5, name: "かなり弱い",          },
    { key: :level6, name: "弱い",                },
  ]
end
