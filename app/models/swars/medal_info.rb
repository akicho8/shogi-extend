module Swars
  class MedalInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "居飛車党",         icon: { method: "tag",  name: "居",                type: "is-light",                          }, func: proc { i_ratio && threshold <= i_ratio                            },},
      { key: "振り飛車党",       icon: { method: "tag",  name: "振",                type: "is-light",                          }, func: proc { i_ratio && i_ratio < (1.0 - threshold)                     },},
      { key: "オールラウンダー", icon: { method: "icon", name: "augmented-reality", type: nil,                                }, func: proc { i_ratio && ((1.0 - threshold)...threshold).cover?(i_ratio) },},

      { key: "嬉野流",           icon: { method: "tag",  name: "嬉",                type: "is-light",                          }, func: proc { ratio_of("嬉野流") >= 0.25                                 },},
      { key: "パックマン戦法",   icon: { method: "icon", name: "pac-man",           type: "is-warning",                        }, func: proc { ratio_of("パックマン戦法") >= 0.1                          },},
      { key: "耀龍マン",         icon: { method: "raw",  name: "🐉",                type: nil,                                }, func: proc { (ratio_of("耀龍四間飛車") + ratio_of("耀龍ひねり飛車")) >= 0.25  },},

      { key: "アヒル初級",       icon: { method: "raw",  name: "🐣",                type: nil,                                }, func: proc { (0.1...0.3).cover?(ratio_of("アヒル囲い"))                       },},
      { key: "アヒル中級",       icon: { method: "raw",  name: "🐥",                type: nil,                                }, func: proc { (0.3...0.5).cover?(ratio_of("アヒル囲い"))                       },},
      { key: "アヒル上級",       icon: { method: "raw",  name: "🐤",                type: nil,                                }, func: proc { (0.5..1.0).cover?(ratio_of("アヒル囲い"))                       },},

      # { key: "穴熊マン",       icon: { method: "raw",  name: "🐤",                type: nil,                                }, func: proc {                   },},

      { key: "切れ負けマン",     icon: { method: "icon", name: "timer-sand-empty",  type: nil, tag_wrap: { type: "is-light" } }, func: proc { lose_count.nonzero? && lose_ratio_of("TIMEOUT") >= 0.25    },},
    ]
  end
end
