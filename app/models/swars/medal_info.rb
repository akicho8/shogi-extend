# app/models/swars/membership_medal_info.rb
# app/javascript/user_info_show.vue
module Swars
  class MedalInfo
    include ApplicationMemoryRecord
    memory_record [
      # 順番はロジックに影響ないが表示順序が変わる

      { key: "居飛車党",           medal_params: { message: "居飛車党",                               method: "tag",  name: "居",                type: "is-light", },   if_cond: proc { ibisha_ratio && threshold <= ibisha_ratio                 },},
      { key: "振り飛車党",         medal_params: { message: "振り飛車党",                             method: "tag",  name: "振",                type: "is-light", },   if_cond: proc { ibisha_ratio && ibisha_ratio < (1.0 - threshold)          },},
      { key: "オールラウンダー",   medal_params: { message: "オールラウンダー",                       method: "icon", name: "augmented-reality", type: nil, },          if_cond: proc { ibisha_ratio && ((1.0 - threshold)...threshold).cover?(ibisha_ratio) },},

      { key: "嬉野マン",           medal_params: { message: "嬉野流の使い手",                         method: "tag",  name: "嬉",                type: "is-light", },   if_cond: proc { win_and_all_tag_ratio_for("嬉野流") >= 0.2                      },},
      { key: "パックマン野郎",     medal_params: { message: "パックマン戦法の使い手",                 method: "icon", name: "pac-man",           type: "is-warning", }, if_cond: proc { win_and_all_tag_ratio_for("パックマン戦法") > 0                 },},
      { key: "耀龍マン",           medal_params: { message: "耀龍戦法の使い手",                       method: "raw",  name: "🐉",                type: nil, },          if_cond: proc { (win_and_all_tag_ratio_for("耀龍四間飛車") + win_and_all_tag_ratio_for("耀龍ひねり飛車")) > 0 },},
      { key: "右玉マン",           medal_params: { message: "右玉党",                                 method: "tag",  name: "右",                type: "is-light", },   if_cond: proc { win_and_all_tag_names_join.include?("右玉") }, },
      { key: "ロケットマン",       medal_params: { message: "ロケットの使い手",                       method: "raw",  name: "🚀",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("ロケット") > 0 },},
      { key: "UFOマン",            medal_params: { message: "UFO銀の使い手",                          method: "raw",  name: "🛸",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("UFO銀") > 0 },},
      { key: "カニ執着マン",       medal_params: { message: "カニ系戦法・囲いの使い手",               method: "raw",  name: "🦀",                type: nil, },          if_cond: proc { (win_and_all_tag_ratio_for("カニカニ銀") > 0 || win_and_all_tag_ratio_for("カニカニ金") > 0) || win_and_all_tag_ratio_for("カニ囲い") >= 0.2 || win_and_all_tag_ratio_for("カニ缶囲い") > 0 },},
      { key: "カメレオンマン",     medal_params: { message: "カメレオン系戦法の使い手",               method: "raw",  name: "🦎",                type: nil, },          if_cond: proc { (win_and_all_tag_ratio_for("英春流カメレオン") > 0) || (win_and_all_tag_ratio_for("カメレオン戦法") > 0) },},
      { key: "ポンポンマン",       medal_params: { message: "ポンポン桂の使い手",                     method: "raw",  name: "🐴",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("ポンポン桂") > 0 },},
      { key: "右四間飛車マン",     medal_params: { message: "右四間飛車の使い手",             method: "raw",  name: "🌋",                type: nil, },          if_cond: proc { (win_and_all_tag_ratio_for("右四間飛車") + win_and_all_tag_ratio_for("右四間飛車急戦") + win_and_all_tag_ratio_for("右四間飛車左美濃")) >= 0.3 }},
      { key: "穴熊マン",           medal_params: { message: "穴熊の使い手",                           method: "raw",  name: "🐻",                type: nil, },          if_cond: proc { win_and_all_tag_names_join.include?("熊") },},
      { key: "ダイヤマン",         medal_params: { message: "ダイヤモンド美濃の使い手",         method: "raw",  name: "💎",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("ダイヤモンド美濃") > 0 },},
      { key: "チョコレートマン",   medal_params: { message: "チョコレート囲いの使い手",         method: "raw",  name: "🍫",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("チョコレート囲い") > 0 },},
      { key: "極限早繰りマン",     medal_params: { message: "極限早繰り銀の使い手",             method: "raw",  name: "🏃🏻",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("極限早繰り銀") > 0 },},
      { key: "坊主マン",           medal_params: { message: "坊主美濃の使い手",                 method: "raw",  name: "👴🏻",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("坊主美濃") > 0 },},
      { key: "中飛車マン",         medal_params: { message: "中飛車の使い手",                         method: "raw",  name: "🀄",                type: nil, },          if_cond: proc { win_and_all_tag_names_join.include?("中飛車") },},
      { key: "レグスペマン",       medal_params: { message: "レグスペの使い手",                 method: "raw",  name: "🐔",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("レグスペ") > 0 },},
      { key: "音無しマン",         medal_params: { message: "音無しの構えの使い手",             method: "raw",  name: "🦉",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("音無しの構え") > 0 },},
      { key: "筋違い角おじさん",   medal_params: { message: "筋違い角おじさん",                       method: "raw",  name: "👨🏻",              type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("筋違い角") > 0 },},
      { key: "スイーツマン",       medal_params: { message: "いちご囲いの使い手",                     method: "raw",  name: "🍓",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("いちご囲い") > 0 },},
      { key: "無敵囲いマン",       medal_params: { message: "無敵囲いの使い手",                       method: "raw",  name: "🔰",                type: nil, },          if_cond: proc { all_tag_ratio_for("無敵囲い") > 0 },},
      { key: "背水マン",           medal_params: { message: "小駒の使い手",                           method: "raw",  name: "🧠",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("背水の陣") > 0 },},
      { key: "エルモマン",         medal_params: { message: "エルモ囲いの使い手",                     method: "raw",  name: "🐒",                type: nil, },          if_cond: proc { win_and_all_tag_ratio_for("エルモ囲い") > 0 },},
      { key: "鬼殺されマン",       medal_params: { message: "鬼殺しを食らって負けた",                 method: "raw",  name: "👹",                type: nil, },          if_cond: proc { defeated_tag_counts["鬼殺し向かい飛車"] > 0 || defeated_tag_counts["鬼殺し"] > 0 || defeated_tag_counts["新鬼殺し"] > 0 },},

      { key: "アヒル初級",         medal_params: { message: "アヒル戦法初級者",                       method: "raw",  name: "🐣",                type: nil, },          if_cond: proc { (0.1...0.3).cover?(all_tag_ratio_for("アヒル囲い"))            },},
      { key: "アヒル中級",         medal_params: { message: "アヒル戦法中級者",                       method: "raw",  name: "🐥",                type: nil, },          if_cond: proc { (0.3...0.5).cover?(all_tag_ratio_for("アヒル囲い"))            },},
      { key: "アヒル上級",         medal_params: { message: "アヒル戦法上級者",                       method: "raw",  name: "🐤",                type: nil, },          if_cond: proc { (0.5..1.0).cover?(all_tag_ratio_for("アヒル囲い")) && win_ratio >= 0.5 },},

      { key: "5連勝",              medal_params: { message: "5連勝以上",                              method: "raw",  name: "🍰",                type: nil, },          if_cond: proc { (5..7).cover?(win_lose_streak_max_hash["win"]) },},
      { key: "8連勝",              medal_params: { message: "8連勝以上",                              method: "raw",  name: "🍣",                type: nil, },          if_cond: proc { (8..10).cover?(win_lose_streak_max_hash["win"]) },},
      { key: "11連勝",             medal_params: { message: "11連勝以上",                             method: "raw",  name: "🏆",                type: nil, },          if_cond: proc { (11..255).cover?(win_lose_streak_max_hash["win"]) },},

      { key: "波が激しいマン",     medal_params: { message: "勝ち負けの波が激しい",                   method: "raw",  name: "🌊",                type: nil, },          if_cond: proc { win_lose_streak_max_hash["win"] >= 5 && win_lose_streak_max_hash["lose"] >= 5 },},

      { key: "居玉勝ちマン",       medal_params: { message: "居玉の使い手",                           method: "raw",  name: "🗿",                type: nil, },          if_cond: proc { (r = igyoku_win_ratio) && r >= 0.1       },},

      { key: "切れ負けマン",       medal_params: { message: "切れ負けが多い",                         method: "raw", name: "⌛",                 type: nil, },           if_cond: proc { (r = lose_ratio_of("TIMEOUT")) && r >= 0.25 },},

      { key: "レアマン",           medal_params: { message: "レア戦法の使い手",                       method: "raw",  name: "🍀",                type: nil, },          if_cond: proc { (r = deviation_avg) && r < 50.0     },},

      { key: "切断マン",           medal_params: { message: "切断の使い手",                          method: "raw",  name: "💩",                type: nil, },          if_cond: proc { (r = lose_ratio_of("DISCONNECT")) && r > 0 },},

      { key: "角不成マン",         medal_params: { message: "角不成の使い手",                           method: "raw",  name: "☠",                 type: nil, },          if_cond: proc { all_tag_ratio_for("角不成") > 0 }           },
      { key: "飛車不成マン",       medal_params: { message: "飛車不成の使い手",                         method: "raw",  name: "💀",                type: nil, },          if_cond: proc { all_tag_ratio_for("飛車不成") > 0 }           },

      { key: "1手詰じらしマン",    medal_params: { message: "1手詰を焦らして歪んだ優越感に浸るのが得意",    method: "raw",  name: "😈",                type: nil, },          if_cond: proc { (r = jirasi_ratio) && r > 0 } },
      { key: "絶対投了しないマン", medal_params: { message: "悔しいときに放置するのが得意", method: "raw",  name: "🧟",                type: nil, },          if_cond: proc { (r = zettai_toryo_sinai_ratio) && r > 0 } },

      { key: "大長考マン",         medal_params: { message: "対局放棄に近いありえないほどの長考をしがち",             method: "raw",  name: "🚫",                type: nil, },          if_cond: proc { (r = long_think_ratio) && r > 0 } },
      { key: "長考マン",           medal_params: { message: "考えすぎて負けることが多い",             method: "raw",  name: "🤯",                type: nil, },          if_cond: proc { (r = short_think_ratio) && r > 0.1 } },

      { key: "開幕千日手",         medal_params: { message: "開幕千日手の使い手",                       method: "raw",  name: "❓",                type: nil },           if_cond: proc { (r = start_draw_ratio) && r > 0 } },
      { key: "ただの千日手",       medal_params: { message: "千日手の使い手",                         method: "icon", name: "💔",                type: nil },          if_cond: proc { (r = draw_ratio) && r > 0 } },

      { key: "棋神マン",           medal_params: { message: "棋神召喚疑惑あり",                       method: "raw",  name: "🤖",                type: nil },           if_cond: proc { ai_use_battle_count >= 1 } },
    ]
  end
end
