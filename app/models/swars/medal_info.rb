# app/models/swars/membership_medal_info.rb
# app/javascript/user_info_show.vue
module Swars
  class MedalInfo
    include ApplicationMemoryRecord
    memory_record [
      # 順番はロジックに影響ないが表示順序が変わる

      { key: "居飛車党",           medal_params: { message: "foo", method: "tag",  name: "居",                type: "is-light", },   if_cond: proc { ibisha_ratio && threshold <= ibisha_ratio                 },},
      { key: "振り飛車党",         medal_params: { message: "foo", method: "tag",  name: "振",                type: "is-light", },   if_cond: proc { ibisha_ratio && ibisha_ratio < (1.0 - threshold)          },},
      { key: "オールラウンダー",   medal_params: { message: "foo", method: "icon", name: "augmented-reality", type: nil, },          if_cond: proc { ibisha_ratio && ((1.0 - threshold)...threshold).cover?(ibisha_ratio) },},

      { key: "嬉野マン",           medal_params: { message: "foo", method: "tag",  name: "嬉",                type: "is-light", },   if_cond: proc { win_and_all_tag_ratio_for("嬉野流") >= 0.2                      },},
      { key: "パックマン野郎",     medal_params: { message: "foo", method: "icon", name: "pac-man",           type: "is-warning", }, if_cond: proc { win_and_all_tag_ratio_for("パックマン戦法") > 0                 },},
      { key: "耀龍マン",           medal_params: { message: "foo", method: "raw",  name: "🐉",                type: nil, },          if_cond: proc { (win_and_all_tag_ratio_for("耀龍四間飛車") + win_and_all_tag_ratio_for("耀龍ひねり飛車")) > 0 },},
      { key: "ロケットマン",       medal_params: { message: "foo", method: "raw",  name: "🚀",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("ロケット") > 0 },},
      { key: "UFOマン",            medal_params: { message: "foo", method: "raw",  name: "🛸",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("UFO銀") > 0 },},
      { key: "カニ執着マン",       medal_params: { message: "foo", method: "raw",  name: "🦀",                type: nil, },          if_cond: proc { (win_and_all_tag_ratio_for("カニカニ銀") > 0 || win_and_all_tag_ratio_for("カニカニ金") > 0) || win_and_all_tag_ratio_for("カニ囲い") >= 0.2 || win_and_all_tag_ratio_for("蟹罐囲い") > 0 },},
      { key: "穴熊マン",           medal_params: { message: "foo", method: "raw",  name: "🐻",                type: nil, },          if_cond: proc { all_tag_names_join.include?("熊") },},
      { key: "ダイヤマン",         medal_params: { message: "foo", method: "raw",  name: "💎",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("ダイヤモンド美濃") > 0 },},
      { key: "レグスペマン",       medal_params: { message: "foo", method: "raw",  name: "🐔",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("レグスペ") > 0 },},
      { key: "音無しマン",         medal_params: { message: "foo", method: "raw",  name: "🦉",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("音無しの構え") > 0 },},
      { key: "筋違い角おじさん",   medal_params: { message: "foo", method: "raw",  name: "🧓",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("筋違い角") > 0 },},
      { key: "スイーツマン",       medal_params: { message: "foo", method: "raw",  name: "🍓",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("いちご囲い") > 0 },},
      { key: "無敵囲いマン",       medal_params: { message: "foo", method: "raw",  name: "🔰",                type: nil, },          if_cond: proc { all_tag_ratio_for("無敵囲い") > 0 },},
      { key: "背水マン",           medal_params: { message: "foo", method: "raw",  name: "🧠",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("背水の陣") > 0 },},
      { key: "エルモマン",         medal_params: { message: "foo", method: "raw",  name: "🐒",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("elmo囲い") > 0 },},
      { key: "鬼殺されマン",       medal_params: { message: "foo", method: "raw",  name: "👹",                type: nil, },          if_cond: proc { defeated_tag_counts["鬼殺し向かい飛車"] > 0 || defeated_tag_counts["鬼殺し"] > 0 || defeated_tag_counts["新鬼殺し"] > 0 },},

      { key: "アヒル初級",         medal_params: { message: "foo", method: "raw",  name: "🐣",                type: nil, },          if_cond: proc { (0.1...0.3).cover?(all_tag_ratio_for("アヒル囲い"))            },},
      { key: "アヒル中級",         medal_params: { message: "foo", method: "raw",  name: "🐥",                type: nil, },          if_cond: proc { (0.3...0.5).cover?(all_tag_ratio_for("アヒル囲い"))            },},
      { key: "アヒル上級",         medal_params: { message: "foo", method: "raw",  name: "🐤",                type: nil, },          if_cond: proc { (0.5..1.0).cover?(all_tag_ratio_for("アヒル囲い")) && win_ratio >= 0.5 },},

      { key: "5連勝",              medal_params: { message: "foo", method: "raw",  name: "🍰",                type: nil, },          if_cond: proc { (5..7).cover?(win_lose_streak_max_hash["win"]) },},
      { key: "8連勝",              medal_params: { message: "foo", method: "raw",  name: "🍣",                type: nil, },          if_cond: proc { (8..10).cover?(win_lose_streak_max_hash["win"]) },},
      { key: "11連勝",             medal_params: { message: "foo", method: "raw",  name: "🏆",                type: nil, },          if_cond: proc { (11..255).cover?(win_lose_streak_max_hash["win"]) },},

      { key: "波が激しいマン",     medal_params: { message: "foo", method: "raw",  name: "🌊",                type: nil, },          if_cond: proc { win_lose_streak_max_hash["win"] >= 5 && win_lose_streak_max_hash["lose"] >= 5 },},

      { key: "居玉勝ちマン",       medal_params: { message: "foo", method: "raw",  name: "🗿",                type: nil, },          if_cond: proc { (r = igyoku_win_ratio) && r >= 0.01       },},

      { key: "切れ負けマン",       medal_params: { message: "foo", method: "raw", name: "⌛",                 type: nil, },           if_cond: proc { (r = lose_ratio_of("TIMEOUT")) && r >= 0.25 },},

      { key: "レアマン",           medal_params: { message: "foo", method: "raw",  name: "🍀",                type: nil, },          if_cond: proc { (r = deviation_avg) && r < 50.0     },},

      { key: "切断マン",           medal_params: { message: "foo", method: "raw",  name: "💩",                type: nil, },          if_cond: proc { (r = lose_ratio_of("DISCONNECT")) && r > 0 },},

      { key: "角不成マン",         medal_params: { message: "foo", method: "raw",  name: "☠",                 type: nil, },          if_cond: proc { all_tag_ratio_for("角不成") > 0 }           },
      { key: "飛車不成マン",       medal_params: { message: "foo", method: "raw",  name: "💀",                type: nil, },          if_cond: proc { all_tag_ratio_for("飛車不成") > 0 }           },

      { key: "一手詰じらしマン",   medal_params: { message: "foo", method: "raw",  name: "😈",                type: nil, },          if_cond: proc { (r = jirasi_ratio) && r > 0 } },
      { key: "絶対投了しないマン", medal_params: { message: "foo", method: "raw",  name: "🧟",                type: nil, },          if_cond: proc { (r = zettai_toryo_sinai_ratio) && r > 0 } },

      { key: "大長考マン",         medal_params: { message: "foo", method: "raw",  name: "🚫",                type: nil, },          if_cond: proc { (r = long_think_ratio) && r > 0 } },
      { key: "長考マン",           medal_params: { message: "foo", method: "raw",  name: "🤯",                type: nil, },          if_cond: proc { (r = short_think_ratio) && r > 0.1 } },

      { key: "開幕千日手",         medal_params: { message: "foo", method: "raw",  name: "❓",                type: nil },           if_cond: proc { (r = start_draw_ratio) && r > 0 } },
      { key: "ただの千日手",       medal_params: { message: "foo", method: "icon", name: "autorenew",         type: "is-danger" },   if_cond: proc { (r = draw_ratio) && r > 0 } },

      { key: "棋神マン",           medal_params: { message: "foo", method: "raw",  name: "🤖",                type: nil },           if_cond: proc { ai_use_battle_count >= 1 } },
    ]
  end
end
