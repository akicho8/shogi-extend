# app/models/swars/membership_medal_info.rb
module Swars
  class MedalInfo
    include ApplicationMemoryRecord
    memory_record [
      # 順番はロジックに影響ないが表示順序が変わる

      { key: "居飛車党",         medal_params: { method: "tag",  name: "居",                type: "is-light",   },        if_cond: proc { ibisha_ratio && threshold <= ibisha_ratio                            },},
      { key: "振り飛車党",       medal_params: { method: "tag",  name: "振",                type: "is-light",   },        if_cond: proc { ibisha_ratio && ibisha_ratio < (1.0 - threshold)                     },},
      { key: "オールラウンダー", medal_params: { method: "medal_params", name: "augmented-reality", type: nil,          },        if_cond: proc { ibisha_ratio && ((1.0 - threshold)...threshold).cover?(ibisha_ratio) },},

      { key: "嬉野マン",         medal_params: { method: "tag",  name: "嬉",                type: "is-light",   },        if_cond: proc { ratio_of("嬉野流") >= 0.2                                 },},
      { key: "パックマン",       medal_params: { method: "medal_params", name: "pac-man",           type: "is-warning", },        if_cond: proc { ratio_of("パックマン戦法") > 0                            },},
      { key: "耀龍マン",         medal_params: { method: "raw",  name: "🐉",                type: nil,          },        if_cond: proc { (ratio_of("耀龍四間飛車") + ratio_of("耀龍ひねり飛車")) > 0  },},
      { key: "ロケットマン",     medal_params: { method: "raw",  name: "🚀",                type: nil,          },        if_cond: proc { ratio_of("ロケット") > 0  },},
      { key: "UFOマン",          medal_params: { method: "raw",  name: "🛸",                type: nil,          },        if_cond: proc { ratio_of("UFO銀") > 0  },},

      { key: "アヒル初級",       medal_params: { method: "raw",  name: "🐣",                type: nil,          },        if_cond: proc { (0.1...0.3).cover?(ratio_of("アヒル囲い"))                       },},
      { key: "アヒル中級",       medal_params: { method: "raw",  name: "🐥",                type: nil,          },        if_cond: proc { (0.3...0.5).cover?(ratio_of("アヒル囲い"))                       },},
      { key: "アヒル上級",       medal_params: { method: "raw",  name: "🐤",                type: nil,          },        if_cond: proc { (0.5..1.0).cover?(ratio_of("アヒル囲い")) && win_ratio >= 0.5    },},

      { key: "居玉勝ちマン",     medal_params: { method: "raw",  name: "🗿",                type: nil,          },        if_cond: proc { (r = igyoku_win_ratio) && r >= 0.01                  },},

      { key: "切れ負けマン", medal_params: { method: "medal_params", name: "timer-sand-empty",  tag_wrap: { type: "is-light" } }, if_cond: proc { (r = lose_ratio_of("TIMEOUT")) && r >= 0.25 },},

      { key: "レアマン",         medal_params: { method: "raw",  name: "🍀",                type: nil, },                 if_cond: proc { (r = deviation_avg) && r < 50.0                 },},

      { key: "切断マン",         medal_params: { method: "raw",  name: "💩",                type: nil,          },        if_cond: proc { (r = lose_ratio_of("DISCONNECT")) && r > 0 },},

      { key: "角不成マン",       medal_params: { method: "raw",  name: "☠",                type: nil,          },         if_cond: proc { ratio_of("角不成") > 0 }                       },
      { key: "飛車不成マン",     medal_params: { method: "raw",  name: "💀",                type: nil,          },        if_cond: proc { ratio_of("飛車不成") > 0 }                       },

      { key: "一手詰じらしマン",    medal_params: { method: "raw",  name: "😈", type: nil, },                             if_cond: proc { (r = jirasi_ratio) && r > 0             } },
      { key: "絶対投了しないマン",  medal_params: { method: "raw",  name: "🧟", type: nil, },                             if_cond: proc { (r = zettai_toryo_sinai_ratio) && r > 0 } },

      { key: "大長考マン",       medal_params: { method: "raw",  name: "😴", type: nil, },                                if_cond: proc { (r = long_think_ratio) && r > 0 } },
      { key: "長考マン",         medal_params: { method: "raw",  name: "😪", type: nil, },                                if_cond: proc { (r = short_think_ratio) && r > 0.1 } },

      { key: "ただの千日手",     medal_params: { method: "medal_params", name: "autorenew",    type: "is-danger" },                  if_cond: proc { (r = draw_ratio) && r > 0    } },
      { key: "千日手異常",       medal_params: { method: "medal_params", name: "alert-circle", type: "is-danger" },                  if_cond: proc { (r = draw_ratio) && r >= 0.1 && new_scope_count >= 10 } },

      { key: "棋神マン",         medal_params: { method: "raw",  name: "🤖",     type: nil },                             if_cond: proc { ai_use_battle_count >= 1 } },

    ]
  end
end
