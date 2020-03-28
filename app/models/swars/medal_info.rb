# app/models/swars/membership_medal_info.rb
module Swars
  class MedalInfo
    include ApplicationMemoryRecord
    memory_record [
      # 順番はロジックに影響ないが表示順序が変わる

      { key: "居飛車党",         icon: { method: "tag",  name: "居",                type: "is-light",   },        func: proc { i_ratio && threshold <= i_ratio                            },},
      { key: "振り飛車党",       icon: { method: "tag",  name: "振",                type: "is-light",   },        func: proc { i_ratio && i_ratio < (1.0 - threshold)                     },},
      { key: "オールラウンダー", icon: { method: "icon", name: "augmented-reality", type: nil,          },        func: proc { i_ratio && ((1.0 - threshold)...threshold).cover?(i_ratio) },},

      { key: "嬉野マン",         icon: { method: "tag",  name: "嬉",                type: "is-light",   },        func: proc { ratio_of("嬉野流") >= 0.2                                 },},
      { key: "パックマン",       icon: { method: "icon", name: "pac-man",           type: "is-warning", },        func: proc { ratio_of("パックマン戦法") > 0                            },},
      { key: "耀龍マン",         icon: { method: "raw",  name: "🐉",                type: nil,          },        func: proc { (ratio_of("耀龍四間飛車") + ratio_of("耀龍ひねり飛車")) > 0  },},
      { key: "ロケットマン",     icon: { method: "raw",  name: "🚀",                type: nil,          },        func: proc { ratio_of("ロケット") > 0  },},
      { key: "UFOマン",          icon: { method: "raw",  name: "🛸",                type: nil,          },        func: proc { ratio_of("UFO銀") > 0  },},

      { key: "アヒル初級",       icon: { method: "raw",  name: "🐣",                type: nil,          },        func: proc { (0.1...0.3).cover?(ratio_of("アヒル囲い"))                       },},
      { key: "アヒル中級",       icon: { method: "raw",  name: "🐥",                type: nil,          },        func: proc { (0.3...0.5).cover?(ratio_of("アヒル囲い"))                       },},
      { key: "アヒル上級",       icon: { method: "raw",  name: "🐤",                type: nil,          },        func: proc { (0.5..1.0).cover?(ratio_of("アヒル囲い")) && win_ratio >= 0.5    },},

      { key: "居玉勝ちマン",     icon: { method: "raw",  name: "🗿",                type: nil,          },        func: proc { (r = igyoku_win_ratio) && r >= 0.01                  },},

      { key: "切れ負けマン", icon: { method: "icon", name: "timer-sand-empty",  tag_wrap: { type: "is-light" } }, func: proc { (r = lose_ratio_of("TIMEOUT")) && r >= 0.25 },},

      { key: "レアマン",         icon: { method: "raw",  name: "🍀",                type: nil, },                 func: proc { (r = deviation_avg) && r < 50.0                 },},

      { key: "切断マン",         icon: { method: "raw",  name: "💩",                type: nil,          },        func: proc { (r = lose_ratio_of("DISCONNECT")) && r > 0 },},

      { key: "角不成マン",       icon: { method: "raw",  name: "☠",                type: nil,          },         func: proc { ratio_of("角不成") > 0 }                       },
      { key: "飛車不成マン",     icon: { method: "raw",  name: "💀",                type: nil,          },        func: proc { ratio_of("飛車不成") > 0 }                       },

      { key: "一手詰じらしマン",    icon: { method: "raw",  name: "😈", type: nil, },                             func: proc { (r = jirasi_ratio) && r > 0             } },
      { key: "絶対投了しないマン",  icon: { method: "raw",  name: "🧟", type: nil, },                             func: proc { (r = zettai_toryo_sinai_ratio) && r > 0 } },

      { key: "大長考マン",       icon: { method: "raw",  name: "😴", type: nil, },                                func: proc { (r = long_think_ratio) && r > 0 } },
      { key: "長考マン",         icon: { method: "raw",  name: "😪", type: nil, },                                func: proc { (r = short_think_ratio) && r > 0.1 } },

      { key: "ただの千日手",     icon: { method: "icon", name: "autorenew", type: "is-danger" },                  func: proc { (r = draw_ratio) && r > 0    } },
      { key: "千日手異常",       icon: { method: "icon", name: "alert",     type: "is-danger" },                  func: proc { (r = draw_ratio) && r >= 0.1 && all_count >= 10 } },

      { key: "棋神マン",         icon: { method: "raw",  name: "🤖",     type: nil },                             func: proc { kishin_use_battle_count >= 1 } },

    ]
  end
end
