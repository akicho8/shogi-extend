# frozen-string-literal: true

# app/models/swars/membership_badge_info.rb
# app/javascript/stat_show.vue

module Swars
  module User::Stat
    class BadgeInfo
      AITETAISEKIMATMAN_MESSAGE = "放置に痺れを切らした相手が離席したころを見計らって着手し逆時間切れ勝ちを狙ったが失敗した"

      include ApplicationMemoryRecord
      memory_record [
        ################################################################################ ネガティブ

        { key: "絶対投了しないマン",     icon: "💩",   message: "悔しかったので時間切れまで放置した",       if_cond: -> { leave_alone_stat.count.positive? } },
        { key: "無気力マン",             icon: "🦥",   message: "無気力な対局をした",                       if_cond: -> { lethargy_stat.exist? } },
        { key: "棋力調整マン",           icon: "⛔",   message: "わざと負けて棋力を調整した",               if_cond: -> { skill_adjust_stat.count.positive? } },
        { key: "大長考マン",             icon: "😴",   message: "対局放棄と受け取られかねない長考をした",   if_cond: -> { prolonged_deliberation_stat.count.positive? } },
        { key: "1手詰焦らしマン",        icon: "😈",   message: "1手詰を焦らして歪んだ優越感に浸った",      if_cond: -> { taunt_mate_stat.count.positive? } },
        { key: "必勝形焦らしマン",       icon: "🎃",   message: "必勝形から焦らして悦に入った",             if_cond: -> { taunt_timeout_stat.count.positive? } },
        { key: "相手退席待ちマン",       icon: "🪰",   message: AITETAISEKIMATMAN_MESSAGE,                  if_cond: -> { waiting_to_leave_stat.count.positive? } },
        { key: "友対無双マン",           icon: "💔",   message: "適切な手合割を選択せず友達相手に無双した", if_cond: -> { xmode_judge_stat.friend_kill_ratio } },
        { key: "道場出禁マン",           icon: "🈲",   message: "道場の平和を乱す将棋を指した",             if_cond: -> { tag_stat.exist?(:"道場出禁") } },

        ################################################################################ 種類

        { key: "居飛車党",               icon: "⬆️",   message: "居飛車党",         if_cond: -> { win_stat.the_ture_master_of_ibis? }, },
        { key: "振り飛車党",             icon: "⬅️",   message: "振り飛車党",       if_cond: -> { win_stat.the_ture_master_of_furi? }, },
        { key: "オールラウンダー",       icon: "🃏",   message: "オールラウンダー", if_cond: -> { win_stat.the_ture_master_of_all_rounder? }, },

        ################################################################################ 列

        { key: "向かい飛車マン",         icon: "8⃣",  message: "向かい飛車の使い手", if_cond: -> { win_stat.exist?(:"九間飛車")  }, },
        { key: "三間飛車マン",           icon: "3⃣",  message: "三間飛車の使い手",   if_cond: -> { win_stat.exist?(:"三間飛車")  }, },
        { key: "四間飛車マン",           icon: "4⃣",  message: "四間飛車の使い手",   if_cond: -> { win_stat.exist?(:"四間飛車")  }, },
        { key: "九間飛車マン",           icon: "9⃣",  message: "九間飛車の使い手",   if_cond: -> { win_stat.exist?(:"九間飛車")  }, },
        { key: "中飛車マン",             icon: "🀄",   message: "中飛車の使い手",     if_cond: -> { win_stat.exist?(:"中飛車")  }, },
        { key: "右四間飛車マン",         icon: "🌋",   message: "右四間飛車の使い手", if_cond: -> { win_stat.exist?(:"右四間飛車")  }, },
        { key: "袖飛車マン",             icon: "👘",   message: "袖飛車の使い手",     if_cond: -> { win_stat.exist?(:"袖飛車")  }, },
        { key: "一間飛車マン",           icon: "1️⃣",   message: "一間飛車の使い手",   if_cond: -> { win_stat.exist?(:"一間飛車") }, },

        ################################################################################ 手筋 / 備考

        { key: "ロケットマン",   icon: "🚀",   message: "ロケットの使い手",   if_cond: -> { win_stat.exist?(:"ロケット") }, },
        { key: "金底マン",       icon: "🪨",   message: "金底の歩の使い手",   if_cond: -> { win_stat.exist?(:"金底の歩") }, },
        { key: "遠見の角マン",   icon: "🔭",   message: "遠見の角の使い手",   if_cond: -> { win_stat.exist?(:"遠見の角") }, },
        { key: "幽霊角マン",     icon: "👻",   message: "幽霊角の使い手",     if_cond: -> { win_stat.exist?(:"幽霊角") }, },
        { key: "土下座マン",     icon: "🙇‍♂️",   message: "土下座の使い手",     if_cond: -> { win_stat.exist?(:"土下座の歩") }, },
        { key: "田楽マン",       icon: "🍢",   message: "田楽刺しの使い手",   if_cond: -> { win_stat.exist?(:"田楽刺し") }, },
        { key: "定跡なしマン",   icon: "🦁",   message: "地力がある",         if_cond: -> { win_stat.exist?(:"力戦") }, },
        { key: "はさみマン",     icon: "✂",   message: "銀ばさみの使い手",   if_cond: -> { win_stat.exist?(:"銀ばさみ") }, },
        { key: "蝮マン",         icon: "🐍",   message: "と金の使い方が上手", if_cond: -> { win_stat.exist?(:"マムシのと金") }, },
        { key: "空中戦マン",     icon: "🦅",   message: "空中戦に強い",       if_cond: -> { win_stat.exist?(:"空中戦") }, },
        { key: "王手飛車マン",   icon: "🦄",   message: "王手飛車を決めた",   if_cond: -> { win_stat.exist?(:"王手飛車") }, },
        { key: "王手角マン",     icon: "🐲",   message: "王手角を決めた",     if_cond: -> { win_stat.exist?(:"王手角") }, },
        { key: "両取りマン",     icon: "🌻",   message: "両取りを決めた",     if_cond: -> { win_stat.exist?(:"両取り") }, },
        { key: "守りの馬マン",   icon: "🐴",   message: "馬の使い方が上手",   if_cond: -> { win_stat.exist?(:"守りの馬") }, },

        ################################################################################ 戦法でかなり勝っているシリーズ

        { key: "棒銀マン",               icon: "🐭️",   message: "棒銀の使い手",               if_cond: -> { win_stat.exist?(:"棒銀") }, },
        { key: "嬉野マン",               icon: "↗️",    message: "嬉野流の使い手",             if_cond: -> { win_stat.exist?(:"嬉野流") }, },
        { key: "パックマン野郎",         icon: "🅿",    message: "パックマンの使い手",           if_cond: -> { win_stat.exist?(:"パックマン戦法") }, },
        { key: "耀龍マン",               icon: "🐉",   message: "耀龍四間飛車の使い手",           if_cond: -> { win_stat.exist?(:"耀龍四間飛車") }, },
        { key: "右玉マン",               icon: "➡",    message: "右玉の使い手",               if_cond: -> { win_stat.exist?(:"右玉") }, },
        { key: "屋敷マン",               icon: "🥷",   message: "屋敷流二枚銀の使い手",       if_cond: -> { win_stat.exist?(:"屋敷流二枚銀") }, },
        { key: "UFOマン",                icon: "🛸",   message: "UFO銀の使い手",              if_cond: -> { win_stat.exist?(:"UFO銀") }, },
        { key: "魔界マン",               icon: "🧛‍♀️",   message: "魔界四間飛車の使い手",     if_cond: -> { win_stat.exist?(:"魔界四間飛車") }, },
        { key: "カニ囲いマン",           icon: "🦀",   message: "カニ囲いの使い手",           if_cond: -> { win_stat.exist?(:"カニ囲い") }, },
        { key: "たこ金マン",             icon: "🪁",   message: "きｍきｍ金の使い手",         if_cond: -> { win_stat.exist?(:"きｍきｍ金") }, },
        { key: "カメレオンマン",         icon: "🦎",   message: "カメレオン戦法の使い手",     if_cond: -> { win_stat.exist?(:"カメレオン戦法") }, },
        { key: "ポンポンマン",           icon: "🦗",   message: "ポンポン桂の使い手",         if_cond: -> { win_stat.exist?(:"ポンポン桂") }, },
        { key: "穴熊マン",               icon: "🐻",   message: "穴熊の使い手",               if_cond: -> { win_stat.exist?(:"穴熊") }, },
        { key: "ダイヤマン",             icon: "💎",   message: "ダイヤモンド美濃の使い手",   if_cond: -> { win_stat.exist?(:"ダイヤモンド美濃")                 }, },
        { key: "チョコレートマン",       icon: "🍫",   message: "チョコレート囲いの使い手",   if_cond: -> { win_stat.exist?(:"チョコレート囲い")                 }, },
        { key: "極限早繰りマン",         icon: "🎸",   message: "極限早繰り銀の使い手",       if_cond: -> { win_stat.exist?(:"極限早繰り銀")                  }, },
        { key: "坊主マン",               icon: "👴🏻",   message: "坊主美濃の使い手",           if_cond: -> { win_stat.exist?(:"坊主美濃")                  }, },
        { key: "レグスペマン",           icon: "🐔",   message: "レグスペの使い手",           if_cond: -> { win_stat.exist?(:"レグスペ")                  }, },
        { key: "音無しマン",             icon: "🦉",   message: "居飛穴音無しの構えの使い手", if_cond: -> { win_stat.exist?(:"居飛穴音無しの構え")                 }, },
        { key: "スイーツマン",           icon: "🍓",   message: "いちご囲いの使い手",         if_cond: -> { win_stat.exist?(:"いちご囲い")                  }, },
        { key: "無敵囲いマン",           icon: "🔰",   message: "無敵囲いの使い手",           if_cond: -> { win_stat.exist?(:"無敵囲い")                  }, },
        { key: "エルモマン",             icon: "🐵",   message: "エルモ囲いの使い手",         if_cond: -> { win_stat.exist?(:"エルモ囲い")                  }, },
        { key: "鬼殺しマン",             icon: "👹",   message: "鬼殺しの使い手",             if_cond: -> { win_stat.exist?(:"鬼殺し") }, },
        { key: "アヒルマン",             icon: "🐥",   message: "アヒル戦法の使い手",         if_cond: -> { win_stat.exist?(:"アヒル戦法") }, },
        { key: "稲庭マン",               icon: "👾",   message: "稲庭戦法の使い手",           if_cond: -> { win_stat.exist?(:"稲庭戦法") }, },
        { key: "雲隠れマン",             icon: "🌥️",   message: "雲隠れ玉の使い手",            if_cond: -> { win_stat.exist?(:"雲隠れ玉") }, },
        { key: "雀刺しマン",             icon: "🪶",   message: "雀刺しの使い手",               if_cond: -> { win_stat.exist?(:"雀刺し") }, },
        { key: "竹スペ乱戦マン",         icon: "🎍",   message: "竹部スペシャルの使い手",     if_cond: -> { win_stat.exist?(:"竹部スペシャル") }, },
        { key: "ゴリ金マン",             icon: "🦍",   message: "ゴリゴリ金の使い手",         if_cond: -> { win_stat.exist?(:"ゴリゴリ金") }, },
        { key: "カギ囲いマン",           icon: "🗝️",   message: "カギ囲いの使い手",            if_cond: -> { win_stat.exist?(:"カギ囲い") }, },
        { key: "都成マン",               icon: "🪤️",   message: "都成流△3一金の使い手",       if_cond: -> { win_stat.exist?(:"都成流△3一金") }, },
        { key: "居玉勝ちマン",           icon: "🗿",   message: "居玉の使い手",                if_cond: -> { win_stat.exist?(:"居玉") }, },
        { key: "入玉勝ちマン",           icon: "🏈",   message: "入玉の使い手",                if_cond: -> { win_stat.exist?(:"入玉") }, },
        { key: "金銀橋マン",             icon: "🌉",   message: "？",                            if_cond: -> { win_stat.exist?(:"リッチブリッジ") }, },

        ################################################################################ 勝ったときに入るタグ

        { key: "吊るし桂マン",           icon: "🪝",   message: "吊るし桂で勝った",               if_cond: -> { tag_stat.exist?(:"吊るし桂") } },
        { key: "雪隠詰めマン",           icon: "🚽",   message: "雪隠詰めで勝った",               if_cond: -> { tag_stat.exist?(:"雪隠詰め") } },
        { key: "姿焼マン",               icon: "🍖",   message: "穴熊を姿焼きにした",             if_cond: -> { tag_stat.exist?(:"穴熊の姿焼き") } },
        { key: "都詰めマン",             icon: "🪬",   message: "都詰めで勝った (超レア)",        if_cond: -> { tag_stat.exist?(:"都詰め") } },
        { key: "ミニマリストマン",       icon: "Ⓜ️",   message: "ミニマリスト",                   if_cond: -> { tag_stat.exist?(:"ミニマリスト") }, },

        ################################################################################ 文言が特殊

        { key: "駒柱マン",               icon: "🗽",   message: "駒柱ができると強くなる",         if_cond: -> { win_stat.exist?(:"駒柱") }  },
        { key: "パンツマン",             icon: "🩲",   message: "パンティを脱ぐと強くなる",       if_cond: -> { win_stat.exist?(:"パンティを脱ぐ") }, },
        { key: "筋違い角マン",           icon: "👨🏻",   message: "筋違い角おじさん",               if_cond: -> { tag_stat.exist?(:"筋違い角") }, },
        { key: "小部屋マン",             icon: "🛖",   message: "銀冠の小部屋の使い手",           if_cond: -> { win_stat.exist?(:"銀冠の小部屋") }, },
        { key: "ブッチマン",             icon: "🧠",   message: "大駒全ブッチの使い手",           if_cond: -> { win_stat.exist?(:"大駒全ブッチ") }, },
        { key: "爆弾マン",               icon: "💣",   message: "ボンバーマン",                   if_cond: -> { tag_stat.exist?(:"5手爆弾") || tag_stat.exist?(:"7手爆弾") }, },
        { key: "パンドラマン",           icon: "🏺",   message: "？",                               if_cond: -> { win_stat.exist?(:"パンドラの歩") }, },
        { key: "二枚飛車マン",           icon: "🦖",   message: "？",                               if_cond: -> { win_stat.exist?(:"二枚飛車") }, },
        { key: "穴熊再生マン",           icon: "🧑‍⚕️",   message: "？",                               if_cond: -> { win_stat.exist?(:"穴熊再生") }, },

        ################################################################################ 特殊

        { key: "急戦マン",               icon: "🐝",   message: "急戦に強い",                     if_cond: -> { rapid_attack_stat.badge?              }, },

        ################################################################################ 連勝

        { key: "勢いマン",               icon: "🔥",   message: "勢いがある",           if_cond: -> { vitality_stat.vital_and_strong? }, },
        { key: "勢いだけマン",           icon: "🔥",   message: "勢いだけはある",       if_cond: -> { vitality_stat.vital_but_weak? }, },
        { key: "5連勝",                  icon: "🍰",   message: "5連勝した",            if_cond: -> { win_lose_streak_stat.five_win? }, },
        { key: "10連勝",                 icon: "🎂",   message: "10連勝した",           if_cond: -> { win_lose_streak_stat.ten_win? }, },
        { key: "波が激しいマン",         icon: "🌊",   message: "勝ち負けの波が激しい", if_cond: -> { win_lose_streak_stat.waves_strong? }, },

        ################################################################################ もっと特殊

        { key: "200手越えマン",          icon: "🏃‍♂️",   message: "長手数の熱戦を制した",                             if_cond: -> { win_turn_stat.max.try { self >= 200 } }, },
        { key: "心強すぎマン",           icon: "🫀",   message: "折れない心の持ち主",                                 if_cond: -> { mental_stat.hard_brain? }, },
        { key: "廃指しマン",             icon: "😡",   message: "局後の検討をすることもなく感情的になって廃指しした", if_cond: -> { daily_average_matches_stat.max.try { self >= 30 } }, },

        { key: "レア戦法マン",           icon: "🍀",   message: "レア (変態) 戦法の使い手",                           if_cond: -> { style_stat.minority_ratio.try { self > 0.5 } }, },
        { key: "長考マン",               icon: "🤯",   message: "考えすぎて負けがち",                                 if_cond: -> { overthinking_loss_stat.badge? } },
        { key: "ただの千日手",           icon: "🍌",   message: "千日手の使い手",                                     if_cond: -> { draw_stat.normal_count.try { positive? } } },
        { key: "運営支えマン",           icon: "🧙‍♂️",   message: "将棋ウォーズの運営を支える力がある",               if_cond: -> { fraud_stat.count.positive? } },
        { key: "示範マン",               icon: "🤵",   message: "マナーが良い",                                       if_cond: -> { gentleman_stat.badge_score.try { self >= 95 } } },

        ################################################################################ 対局モード x 対局ルール x 勝敗

        { key: "友対GGマン",             icon: "❤️",   message: "良い感じの友達対局をした", if_cond: -> { xmode_judge_stat.friend_battle_sessatakuma? } },
        { key: "指導受けマン",           icon: "👨‍🎓",   message: "指導対局を受けた",      if_cond: -> { xmode_stat.versus_pro? } },
        { key: "プロ越えマン",           icon: "🥋️",   message: "野生のプロ棋士",          if_cond: -> { !user.grade_info.teacher && pro_skill_exceed_stat.counts_hash[:win] } },

        ################################################################################ 不成

        { key: "不成勝ちマン",           icon: "🤡",   message: "舐めプして勝った",    if_cond: -> { tag_stat.win_with?(:"角不成") || tag_stat.win_with?(:"飛車不成") }  },
        { key: "不成負けマン",           icon: "🦟",   message: "舐めプして負けた",    if_cond: -> { tag_stat.lose_with?(:"角不成") || tag_stat.lose_with?(:"飛車不成") }  },
        { key: "VS不成勝ちマン",         icon: "👮‍♂️",   message: "成らず者を成敗した",  if_cond: -> { op_tag_stat.lose_with?(:"角不成") || op_tag_stat.lose_with?(:"飛車不成") } },
        { key: "VS不成負けマン",         icon: "🌚",   message: "成らず者に負けた",    if_cond: -> { op_tag_stat.win_with?(:"角不成") || op_tag_stat.win_with?(:"飛車不成") } },

        ################################################################################ 全駒・玉単騎

        { key: "全駒マン",             icon: "🦈", message: "詰まさずに全駒した",     if_cond: -> { tag_stat.exist?(:"全駒") }, },
        { key: "玉単騎マン",           icon: "🏴‍☠️", message: "意地でも投了しなかった", if_cond: -> { tag_stat.exist?(:"玉単騎") }, },

        ################################################################################ 駒の使用率

        { key: "玉使いこなしマン", icon: "👑", message: "玉を動かしまくるタイプ",  if_cond: -> { piece_master_stat.badge?(:"玉") } },
        # { key: "飛使いこなしマン", icon: "🐲", message: "飛車大好き",              if_cond: -> { piece_master_stat.badge?(:"飛") } },
        # { key: "角使いこなしマン", icon: "🦄", message: "角大好き",               if_cond: -> { piece_master_stat.badge?(:"角") } },
        # { key: "金使いこなしマン", icon: "🛡",  message: "金が大好き",             if_cond: -> { piece_master_stat.badge?(:"金") } },
        # { key: "銀使いこなしマン", icon: "⚔",  message: "銀が大好き",             if_cond: -> { piece_master_stat.badge?(:"銀") } },
        { key: "桂使いこなしマン", icon: "🐸", message: "？",         if_cond: -> { piece_master_stat.badge?(:"桂") } },
        # { key: "香使いこなしマン", icon: "🎯", message: "香を活用しがち",         if_cond: -> { piece_master_stat.badge?(:"香") } },
        # { key: "歩使いこなしマン", icon: "🗡",  message: "小太刀の名手",           if_cond: -> { piece_master_stat.badge?(:"歩") } },

        ################################################################################ 結末

        { key: "切断マン",       icon: "🪳",   message: "切断逃亡の使い手",   if_cond: -> { judge_final_stat.count_by(:lose, :DISCONNECT).try { self >= 1 } }, },
        { key: "持将棋勝ちマン", icon: "⚖",    message: "持将棋で勝った",     if_cond: -> { judge_final_stat.count_by(:win, :ENTERINGKING).try { self >= 1 } }, },
        { key: "投了マン",       icon: "🤚",   message: "投了を究めし者",     if_cond: -> { judge_final_stat.master_ratio(:TORYO).try { self == 1.0 } }, },
        { key: "詰まされマン",   icon: "🩸️",   message: "マゾの傾向がある",   if_cond: -> { judge_final_stat.master_ratio(:CHECKMATE).try { self == 1.0 } }, },
        { key: "切れ負けマン",   icon: "⌛",   message: "時間の使い方が下手", if_cond: -> { judge_final_stat.master_ratio(:TIMEOUT).try { self >= 0.25 } }, },
        { key: "タイムキーパー", icon: "⏰",   message: "時間の使い方が上手", if_cond: -> { judge_final_stat.master_ratio(:TIMEOUT).try { self == 0 } }, },

        ################################################################################ 隠れキャラ

        { key: "ただのサンタ", icon: "🎅",  message: "", if_cond: -> { Time.current.then { |t| (t.month == 12 && t.day == 24) || Rails.env.local? } }, },
      ]
    end
  end
end
