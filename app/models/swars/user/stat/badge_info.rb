# frozen-string-literal: true

# app/models/swars/membership_badge_info.rb
# app/javascript/stat_show.vue

module Swars
  module User::Stat
    class BadgeInfo
      AITETAISEKIMATMAN_MESSAGE = "放置に痺れを切らした相手が離席したころを見計らって着手し逆時間切れ勝ちを狙ったが失敗した"

      include ApplicationMemoryRecord
      memory_record [
        ################################################################################ ネガティブなバッジ

        { key: "絶対投了しないマン",     icon: "🪳",   message: "悔しかったので時間切れまで放置した",     if_cond: proc { leave_alone_stat.count.positive? } },
        { key: "無気力マン",             icon: "🦥",   message: "無気力な対局をした",                     if_cond: proc { lethargy_stat.exist? } },
        { key: "棋力調整マン",           icon: "🦇",   message: "わざと負けて棋力を調整した",             if_cond: proc { skill_adjust_stat.exist? } },
        { key: "大長考マン",             icon: "😴",   message: "対局放棄と受け取られかねない長考をした", if_cond: proc { prolonged_deliberation_stat.count.positive? } },
        { key: "1手詰じらしマン",        icon: "😈",   message: "1手詰を焦らして歪んだ優越感に浸った",    if_cond: proc { taunt_mate_stat.count.positive? } },
        { key: "必勝形じらしマン",       icon: "😈",   message: "必勝形から焦らして優越感に浸った",       if_cond: proc { taunt_timeout_stat.count.positive? } },
        { key: "相手退席待ちマン",       icon: "🧌",   message: AITETAISEKIMATMAN_MESSAGE,                if_cond: proc { waiting_to_leave_stat.count.positive? } },
        { key: "友対無双マン",           icon: "💔",   message: "友達対局で友達を無くした",               if_cond: proc { xmode_judge_stat.friend_kill_ratio } },

        ################################################################################

        { key: "居飛車党",               icon: "⬆️",    message: "真の居飛車党",         if_cond: proc { win_stat.the_ture_master_of_ibis? },},
        { key: "振り飛車党",             icon: "⬅️",   message: "真の振り飛車党",       if_cond: proc { win_stat.the_ture_master_of_furi? },},
        { key: "オールラウンダー",       icon: "🃏",   message: "真のオールラウンダー", if_cond: proc { win_stat.the_ture_master_of_all_rounder? },},

        ################################################################################

        { key: "三間飛車マン",           icon: "3⃣",    message: "三間飛車の匠",     if_cond: proc { win_stat.match?(/三間|石田/) },},
        { key: "四間飛車マン",           icon: "4⃣",    message: "四間飛車の匠",     if_cond: proc { win_stat.match?(/(?<!右)四間飛車/) },},
        { key: "九間飛車マン",           icon: "9⃣",    message: "九間飛車の先駆者", if_cond: proc { win_stat.include?("九間飛車") }, },
        { key: "中飛車マン",             icon: "🀄",   message: "中飛車名人",       if_cond: proc { win_stat.include?("中飛車") },},
        { key: "右四間飛車マン",         icon: "🦖",   message: "右四間飛車の匠",   if_cond: proc { win_stat.include?("右四間") }, },
        { key: "袖飛車マン",             icon: "👘",   message: "袖飛車の奇人",     if_cond: proc { win_stat.exist?(:"袖飛車") },},
        { key: "一間飛車マン",           icon: "1️⃣",    message: "一間飛車の異端児", if_cond: proc { win_stat.include?("一間飛車") }, },

        ################################################################################ 手筋

        { key: "ロケットマン", icon: "🚀",   message: "ロケットの名手",           if_cond: proc { win_stat.exist?(:"ロケット") },},
        { key: "金底マン",     icon: "🪨",   message: "金底の歩の使い所が上手",   if_cond: proc { win_stat.exist?(:"金底の歩") },},
        { key: "遠見の角マン", icon: "🔭",   message: "遠見の角の名手",           if_cond: proc { win_stat.exist?(:"遠見の角") },},
        { key: "幽霊角マン",   icon: "👻",   message: "幽霊角の名手",             if_cond: proc { win_stat.exist?(:"幽霊角") },},

        ################################################################################ 単純な勝ち越しシリーズ

        { key: "棒銀マン",               icon: "🐭️",   message: "棒銀の使い手",               if_cond: proc { win_stat.include?("棒銀") },},
        { key: "嬉野マン",               icon: "↗️",    message: "嬉野流の使い手",             if_cond: proc { win_stat.include?("嬉野流") },},
        { key: "パックマン野郎",         icon: "🅿",    message: "パックマンの達人",           if_cond: proc { win_stat.include?("パックマン") },},
        { key: "耀龍マン",               icon: "🐉",   message: "耀龍戦法の使い手",           if_cond: proc { win_stat.include?("耀龍") }, },
        { key: "右玉マン",               icon: "➡",    message: "右玉の匠",                   if_cond: proc { win_stat.include?("右玉") }, },
        { key: "屋敷マン",               icon: "🥷",   message: "屋敷流二枚銀の使い手",       if_cond: proc { win_stat.include?("屋敷流二枚銀") },},
        { key: "UFOマン",                icon: "🛸",   message: "UFO銀の使い手",              if_cond: proc { win_stat.exist?(:"UFO銀") },},
        { key: "カニ囲いマン",           icon: "🦀",   message: "カニ囲いの使い手",           if_cond: proc { win_stat.exist?(:"カニ囲い") },},
        { key: "たこ金マン",             icon: "🪁",   message: "きｍきｍ金の使い手",         if_cond: proc { win_stat.exist?(:"きｍきｍ金") },},
        { key: "カメレオンマン",         icon: "🦎",   message: "カメレオン戦法の使い手",     if_cond: proc { win_stat.exist?(:"カメレオン戦法") },},
        { key: "ポンポンマン",           icon: "🦗",   message: "ポンポン桂の使い手",         if_cond: proc { win_stat.exist?(:"ポンポン桂") },},
        { key: "穴熊マン",               icon: "🐻",   message: "穴熊名人",                   if_cond: proc { win_stat.include?("熊") },},
        { key: "ダイヤマン",             icon: "💎",   message: "ダイヤモンド美濃の使い手",   if_cond: proc { win_stat.exist?(:"ダイヤモンド美濃")                 },},
        { key: "チョコレートマン",       icon: "🍫",   message: "チョコレート囲いの使い手",   if_cond: proc { win_stat.exist?(:"チョコレート囲い")                 },},
        { key: "極限早繰りマン",         icon: "🎸",   message: "極限早繰り銀の使い手",       if_cond: proc { win_stat.exist?(:"極限早繰り銀")                  },},
        { key: "坊主マン",               icon: "👴🏻", message: "坊主美濃の使い手",           if_cond: proc { win_stat.exist?(:"坊主美濃")                  },},
        { key: "レグスペマン",           icon: "🐔",   message: "レグスペの使い手",           if_cond: proc { win_stat.exist?(:"レグスペ")                  },},
        { key: "音無しマン",             icon: "🦉",   message: "居飛穴音無しの構えの使い手", if_cond: proc { win_stat.exist?(:"居飛穴音無しの構え")                 },},
        { key: "スイーツマン",           icon: "🍓",   message: "いちご囲いの使い手",         if_cond: proc { win_stat.exist?(:"いちご囲い")                  },},
        { key: "無敵囲いマン",           icon: "🔰",   message: "無敵囲いのスペシャリスト",   if_cond: proc { win_stat.exist?(:"無敵囲い")                  },},
        { key: "エルモマン",             icon: "🐵",   message: "エルモ囲いの使い手",         if_cond: proc { win_stat.exist?(:"エルモ囲い")                  },},
        { key: "鬼殺しマン",             icon: "👹",   message: "鬼殺しの使い手",             if_cond: proc { win_stat.include?("鬼殺し") },},
        { key: "アヒルマン",             icon: "🐥",   message: "アヒル戦法の匠",             if_cond: proc { win_stat.exist?(:"アヒル戦法") },},
        { key: "稲庭マン",               icon: "👾",   message: "稲庭戦法のエキスパート",     if_cond: proc { win_stat.exist?(:"稲庭戦法") },},
        { key: "居玉勝ちマン",           icon: "🗿",   message: "居玉の達人",                 if_cond: proc { win_stat.exist?(:"居玉") }, },
        { key: "入玉勝ちマン",           icon: "🏈",   message: "入玉の達人",                 if_cond: proc { win_stat.exist?(:"入玉") }, },

        ################################################################################ 文言が特殊

        { key: "駒柱マン",               icon: "🗽",   message: "駒柱の作り手",             if_cond: proc { win_stat.exist?(:"駒柱") }  },
        { key: "パンツマン",             icon: "🩲",   message: "パンツを脱いで強くなった", if_cond: proc { win_stat.exist?(:"パンツを脱ぐ") }, },
        { key: "小部屋マン",             icon: "🛖",   message: "銀冠の小部屋を活用した",   if_cond: proc { win_stat.exist?(:"銀冠の小部屋") },},
        { key: "都詰めマン",             icon: "🪬",   message: "都詰めマスター (超レア)",  if_cond: proc { win_stat.exist?(:"都詰め") } },
        { key: "ブッチマン",             icon: "🧠",   message: "大駒全ブッチの達人",       if_cond: proc { win_stat.exist?(:"大駒全ブッチ") },},
        { key: "筋違い角マン",           icon: "👨🏻", message: "筋違い角おじさん",         if_cond: proc { win_stat.exist?(:"筋違い角") },},

        ################################################################################ 特殊

        { key: "急戦マン",               icon: "🐝",   message: "急戦のエキスパート", if_cond: proc { rapid_attack_stat.badge?              },},

        ################################################################################

        { key: "10連勝",                 icon: "🔥",   message: "10連勝した",           if_cond: proc { win_lose_streak_stat.ten_win? },},
        { key: "波が激しいマン",         icon: "🌊",   message: "勝ち負けの波が激しい", if_cond: proc { win_lose_streak_stat.waves_strong? },},

        ################################################################################

        { key: "200手越えマン",          icon: "🌻️",   message: "長手数の熱戦を制した",                                if_cond: proc { win_turn_stat.max.try { self >= 200 } },},
        { key: "心強すぎマン",           icon: "🫀",   message: "折れない心の持ち主",                                 if_cond: proc { mental_stat.hard_brain? },},
        { key: "廃指しマン",             icon: "😡",   message: "局後の検討をすることもなく感情的になって廃指しした", if_cond: proc { daily_average_matches_stat.max.try { self >= 30 } },},

        { key: "レア戦法マン",           icon: "🍀",   message: "変態戦法の匠",                                       if_cond: proc { rarity_stat.minority?                    },},
        { key: "長考マン",               icon: "🤯",   message: "考えすぎて負けがち",                                 if_cond: proc { overthinking_loss_stat.badge? } },
        { key: "ただの千日手",           icon: "🍌",   message: "千日手の使い手",                                     if_cond: proc { draw_stat.normal_count.try { positive? } } },
        { key: "運営支えマン",           icon: "🧙‍♂️", message: "将棋ウォーズの運営を支える力がある",                 if_cond: proc { fraud_stat.count.positive? } },
        { key: "示範マン",               icon: "🤵",   message: "行動規範を究めた",                                   if_cond: proc { gentleman_stat.badge? } },

        ################################################################################ 対局モード x 対局ルール x 勝敗

        { key: "友対GGマン",             icon: "❤️",    message: "友達対局で切磋琢磨した",                             if_cond: proc { xmode_judge_stat.friend_battle_sessatakuma? } },
        { key: "指導受けマン",           icon: "👨‍🎓", message: "指導対局を受けた",                                   if_cond: proc { xmode_stat.versus_pro? } },
        { key: "プロ越えマン",           icon: "🦁",   message: "野生のプロ棋士",                                     if_cond: proc { !user.grade_info.teacher && pro_skill_exceed_stat.counts_hash[:win] } },

        ################################################################################

        { key: "角不成勝ちマン",         icon: "🤡",   message: "角不成の舐めプをかました上で勝った",                 if_cond: proc { tag_stat.win_with?(:"角不成") }  },
        { key: "角不成負けマン",         icon: "🧟",   message: "角不成をして返り討ちにあった",                       if_cond: proc { tag_stat.lose_with?(:"角不成") }  },
        { key: "飛車不成勝ちマン",       icon: "🤡",   message: "飛車不成の舐めプをかました上で勝った",               if_cond: proc { tag_stat.win_with?(:"飛車不成") }  },
        { key: "飛車不成負けマン",       icon: "🧟",   message: "飛車不成をして返り討ちにあった",                     if_cond: proc { tag_stat.lose_with?(:"飛車不成") }  },
        { key: "VS角不成勝ちマン",       icon: "😏",   message: "角不成者を返り討ちにした",                           if_cond: proc { op_tag_stat.lose_with?(:"角不成")      } },
        { key: "VS角不成負けマン",       icon: "😒",   message: "角不成で舐めプされた上に負けた",                     if_cond: proc { op_tag_stat.win_with?(:"角不成")   } },
        { key: "VS飛車不成勝ちマン",     icon: "😏",   message: "飛車不成者を返り討ちにした",                         if_cond: proc { op_tag_stat.lose_with?(:"飛車不成")      } },
        { key: "VS飛車不成負けマン",     icon: "😒",   message: "飛車不成で舐めプされた上に負けた",                   if_cond: proc { op_tag_stat.win_with?(:"飛車不成")   } },

        ################################################################################ 駒の使用率

        { key: "玉使いこなしマン", icon: "👑", message: "玉の使い方が上手",   if_cond: proc { piece_master_stat.win_average_above?(:"玉") } },
        { key: "飛使いこなしマン", icon: "🐲", message: "飛車の使い方が上手", if_cond: proc { piece_master_stat.win_average_above?(:"飛") } },
        { key: "角使いこなしマン", icon: "🦄", message: "角の使い方が上手",   if_cond: proc { piece_master_stat.win_average_above?(:"角") } },
        { key: "金使いこなしマン", icon: "🛡", message: "金の使い方が上手",    if_cond: proc { piece_master_stat.win_average_above?(:"金") } },
        { key: "銀使いこなしマン", icon: "⚔", message: "銀の使い方が上手",    if_cond: proc { piece_master_stat.win_average_above?(:"銀") } },
        { key: "桂使いこなしマン", icon: "🐸", message: "桂馬の使い方が上手", if_cond: proc { piece_master_stat.win_average_above?(:"桂") } },
        { key: "香使いこなしマン", icon: "🍢", message: "香車の使い方が上手", if_cond: proc { piece_master_stat.win_average_above?(:"香") } },
        { key: "歩使いこなしマン", icon: "🗡", message: "歩の使い方が上手",    if_cond: proc { piece_master_stat.win_average_above?(:"歩") } },

        ################################################################################ 結末

        { key: "切断マン",       icon: "💩",   message: "切断の使い手",       if_cond: proc { judge_final_stat.count_by(:lose, :DISCONNECT).try { self >= 1 } },},
        { key: "投了マン",       icon: "🙇‍♂️", message: "投了を究めた",       if_cond: proc { judge_final_stat.master_ratio(:TORYO).try { self == 1.0 } }, },
        { key: "詰まされマン",   icon: "Ⓜ️",    message: "Mの傾向がある",      if_cond: proc { judge_final_stat.master_ratio(:CHECKMATE).try { self == 1.0 } }, },
        { key: "切れ負けマン",   icon: "⌛",   message: "切れ負けの常連",     if_cond: proc { judge_final_stat.master_ratio(:TIMEOUT).try { self >= 0.25 } },},
        { key: "タイムキーパー", icon: "⏰",   message: "時間の使い方が上手", if_cond: proc { judge_final_stat.master_ratio(:TIMEOUT).try { self == 0 } },},
      ]
    end
  end
end
