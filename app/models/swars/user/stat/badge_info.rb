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

        { key: "切断マン",           badge_params: { name: "💩",   message: "切断の使い手",                            }, if_cond: proc { (stat.judge_final_stat.count_by(:lose, :DISCONNECT) || 0).positive? },},
        { key: "絶対投了しないマン", badge_params: { name: "🪳",   message: "悔しかったので時間切れまで放置した",      }, if_cond: proc { stat.leave_alone_stat.count.positive? } },
        { key: "無気力マン",         badge_params: { name: "🦥",   message: "無気力な対局をした",                      }, if_cond: proc { stat.lethargy_stat.exist? } },
        { key: "大長考マン",         badge_params: { name: "😴",   message: "対局放棄と受け取られかねない長考をした",  }, if_cond: proc { stat.prolonged_deliberation_stat.count.positive? } },
        { key: "1手詰じらしマン",    badge_params: { name: "😈",   message: "1手詰を焦らして歪んだ優越感に浸った",     }, if_cond: proc { stat.mate_stat.count.positive? } },
        { key: "相手退席待ちマン",   badge_params: { name: "🪰",   message: AITETAISEKIMATMAN_MESSAGE,                 }, if_cond: proc { stat.waiting_to_leave_stat.count.positive? } },
        { key: "角不成マン",         badge_params: { name: "☠",    message: "角不成で舐めプした",                    }, if_cond: proc { stat.tag_stat.counts_hash.has_key?(:"角不成") }  },
        { key: "飛車不成マン",       badge_params: { name: "💀",   message: "飛車不成で舐めプした",                   }, if_cond: proc { stat.tag_stat.counts_hash.has_key?(:"飛車不成") }  },

        ################################################################################

        { key: "居飛車党",           badge_params: { name: "⬆️",     message: "真の居飛車党",         }, if_cond: proc { win_stat.the_ture_master_of_ibis? },},
        { key: "振り飛車党",         badge_params: { name: "⬅️",    message: "真の振り飛車党",       }, if_cond: proc { win_stat.the_ture_master_of_furi? },},
        { key: "オールラウンダー",   badge_params: { name: "🅰",    message: "真のオールラウンダー", }, if_cond: proc { win_stat.the_ture_master_of_all_rounder? },},

        ################################################################################

        { key: "三間飛車マン",   badge_params: { name: "3⃣", message: "三間飛車の匠",          }, if_cond: proc { win_stat.match?(/三間|石田/) },},
        { key: "四間飛車マン",   badge_params: { name: "4⃣", message: "四間飛車の匠",          }, if_cond: proc { win_stat.match?(/(?<!右)四間飛車/) },},
        { key: "九間飛車マン",   badge_params: { name: "9⃣", message: "九間飛車のパイオニア",  }, if_cond: proc { win_stat.include?("九間飛車") }, },
        { key: "中飛車マン",     badge_params: { name: "🀄",   message: "中飛車名人",            }, if_cond: proc { win_stat.include?("中飛車") },},
        { key: "右四間飛車マン", badge_params: { name: "⚔",    message: "右四間に砕けないものはナイ", }, if_cond: proc { win_stat.include?("右四間") }, },
        { key: "袖飛車マン",     badge_params: { name: "👘",   message: "袖飛車の奇人",          }, if_cond: proc { win_stat.exist?(:"袖飛車") },},
        { key: "一間飛車マン",   badge_params: { name: "1️⃣",    message: "一間飛車の異端児",      }, if_cond: proc { win_stat.include?("一間飛車") }, },

        ################################################################################ 手筋

        { key: "ロケットマン",       badge_params: { name: "🚀",   message: "ロケットの名手",           }, if_cond: proc { win_stat.exist?(:"ロケット") },},
        { key: "金底マン",           badge_params: { name: "🪨",   message: "金底の歩を効果的に使った", }, if_cond: proc { win_stat.exist?(:"金底の歩") },},
        { key: "遠見の角マン",       badge_params: { name: "🔭",   message: "遠見の角の名手",           }, if_cond: proc { win_stat.exist?(:"遠見の角") },},
        { key: "幽霊角マン",         badge_params: { name: "👻",   message: "幽霊角の名手",              }, if_cond: proc { win_stat.exist?(:"幽霊角")                   },},

        ################################################################################ 単純な勝ち越しシリーズ

        { key: "嬉野マン",           badge_params: { name: "↗️",    message: "嬉野流の使い手",             }, if_cond: proc { win_stat.include?("嬉野流") },},
        { key: "パックマン野郎",     badge_params: { name: "🅿",    message: "パックマンの達人",          }, if_cond: proc { win_stat.include?("パックマン") },},
        { key: "耀龍マン",           badge_params: { name: "🐉",   message: "耀龍戦法の使い手",           }, if_cond: proc { win_stat.include?("耀龍") }, },
        { key: "右玉マン",           badge_params: { name: "➡",    message: "右玉の匠",                  }, if_cond: proc { win_stat.include?("右玉") }, },
        { key: "屋敷マン",           badge_params: { name: "🥷",   message: "屋敷流二枚銀の使い手",       }, if_cond: proc { win_stat.include?("屋敷流二枚銀") },},
        { key: "UFOマン",            badge_params: { name: "🛸",   message: "UFO銀の使い手",              }, if_cond: proc { win_stat.exist?(:"UFO銀") },},
        { key: "カニ執着マン",       badge_params: { name: "🦀",   message: "カニ系戦法の使い手",         }, if_cond: proc { win_stat.include?("カニ") },},
        { key: "カメレオンマン",     badge_params: { name: "🦎",   message: "カメレオン系戦法の使い手",   }, if_cond: proc { win_stat.include?("カメレオン") },},
        { key: "ポンポンマン",       badge_params: { name: "🦗",   message: "ポンポン桂の使い手",         }, if_cond: proc { win_stat.exist?(:"ポンポン桂") },},
        { key: "穴熊マン",           badge_params: { name: "🐻",   message: "穴熊名人",                   }, if_cond: proc { win_stat.include?("熊") },},
        { key: "ダイヤマン",         badge_params: { name: "💎",   message: "ダイヤモンド美濃の使い手",   }, if_cond: proc { win_stat.exist?(:"ダイヤモンド美濃")                 },},
        { key: "チョコレートマン",   badge_params: { name: "🍫",   message: "チョコレート囲いの使い手",   }, if_cond: proc { win_stat.exist?(:"チョコレート囲い")                 },},
        { key: "極限早繰りマン",     badge_params: { name: "🏃🏻", message: "極限早繰り銀の使い手",       }, if_cond: proc { win_stat.exist?(:"極限早繰り銀")                  },},
        { key: "坊主マン",           badge_params: { name: "👴🏻", message: "坊主美濃の使い手",           }, if_cond: proc { win_stat.exist?(:"坊主美濃")                  },},
        { key: "レグスペマン",       badge_params: { name: "🐔",   message: "レグスペの使い手",           }, if_cond: proc { win_stat.exist?(:"レグスペ")                  },},
        { key: "音無しマン",         badge_params: { name: "🦉",   message: "居飛穴音無しの構えの使い手", }, if_cond: proc { win_stat.exist?(:"居飛穴音無しの構え")                 },},
        { key: "スイーツマン",       badge_params: { name: "🍓",   message: "いちご囲いの使い手",         }, if_cond: proc { win_stat.exist?(:"いちご囲い")                  },},
        { key: "無敵囲いマン",       badge_params: { name: "🔰",   message: "無敵囲いのスペシャリスト",    }, if_cond: proc { win_stat.exist?(:"無敵囲い")                  },},
        { key: "エルモマン",         badge_params: { name: "🐒",   message: "エルモ囲いの使い手",         }, if_cond: proc { win_stat.exist?(:"エルモ囲い")                  },},
        { key: "鬼殺しマン",         badge_params: { name: "👹",   message: "鬼殺しの使い手",             }, if_cond: proc { win_stat.include?("鬼殺し") },},
        { key: "アヒルマン",         badge_params: { name: "🐥",   message: "アヒル戦法の名匠",           }, if_cond: proc { win_stat.exist?(:"アヒル戦法") },},
        { key: "稲庭マン",           badge_params: { name: "👾",   message: "稲庭戦法のエキスパート",     }, if_cond: proc { win_stat.exist?(:"稲庭戦法") },},
        { key: "居玉勝ちマン",       badge_params: { name: "🗿",   message: "居玉の達人",                 }, if_cond: proc { win_stat.exist?(:"居玉") }, },
        { key: "入玉勝ちマン",       badge_params: { name: "🏈",   message: "入玉の達人",                 }, if_cond: proc { win_stat.exist?(:"入玉") }, },

        ################################################################################ 文言が特殊

        { key: "駒柱マン",           badge_params: { name: "🗽",   message: "駒柱の作り手",               }, if_cond: proc { win_stat.exist?(:"駒柱") }  },
        { key: "パンツマン",         badge_params: { name: "🩲",   message: "パンツを脱ぐと強くなる",     }, if_cond: proc { win_stat.exist?(:"パンツを脱ぐ") }, },
        { key: "小部屋マン",         badge_params: { name: "🛖",   message: "銀冠の小部屋を活用した",     }, if_cond: proc { win_stat.exist?(:"銀冠の小部屋") },},
        { key: "都詰めマン",         badge_params: { name: "🏯",   message: "都詰めマスター (超レア)",    }, if_cond: proc { win_stat.exist?(:"都詰め") } },
        { key: "ブッチマン",         badge_params: { name: "🧠",   message: "大駒全ブッチの達人",         }, if_cond: proc { win_stat.exist?(:"大駒全ブッチ") },},
        { key: "筋違い角マン",       badge_params: { name: "👨🏻", message: "筋違い角おじさん",           }, if_cond: proc { win_stat.exist?(:"筋違い角") },},

        ################################################################################ 特殊

        { key: "急戦マン",           badge_params: { name: "🐝",    message: "急戦のエキスパート",                 }, if_cond: proc { stat.rapid_attack_stat.badge?              },},

        ################################################################################

        { key: "10連勝",             badge_params: { name: "🔥",   message: "10連勝した",                         }, if_cond: proc { win_lose_streak_stat.ten_win? },},
        { key: "10連敗",             badge_params: { name: "⛈",   message: "10連敗した",                         }, if_cond: proc { win_lose_streak_stat.ten_lose? },},
        { key: "波が激しいマン",     badge_params: { name: "🌊",   message: "勝ち負けの波が激しい",               }, if_cond: proc { win_lose_streak_stat.waves_strong? },},

        ################################################################################

        { key: "200手越えマン",      badge_params: { name: "⚡️",    message: "200手以上で勝った",                  }, if_cond: proc { (stat.win_turn_stat.max || 0) >= 200 },},
        { key: "心強すぎマン",       badge_params: { name: "🫀",   message: "折れない心の持ち主",                 }, if_cond: proc { stat.mental_stat.hard_brain? },},
        { key: "廃指しマン",         badge_params: { name: "😡",   message: "感情的になって廃指しした",           }, if_cond: proc { (stat.daily_average_matches_stat.max || 0) >= 30 },},

        { key: "投了マン",           badge_params: { name: "🙇‍♂️", message: "投了を究めた",                       }, if_cond: proc { (stat.judge_final_stat.toryo_ratio || 0) >= 1.0 }, },
        { key: "詰まされマン",       badge_params: { name: "Ⓜ️",   message: "マゾヒストの傾向がある",             }, if_cond: proc { (stat.judge_final_stat.checkmate_ratio || 0) >= 1.0 }, },
        { key: "切れ負けマン",       badge_params: { name: "⌛",   message: "切れ負けの常連",                     }, if_cond: proc { (stat.judge_final_stat.ratio_by(:lose, :TIMEOUT) || 0) >= 0.25 },},
        { key: "レア戦法マン",       badge_params: { name: "🍀",   message: "変態戦法の匠",                       }, if_cond: proc { stat.rarity_stat.minority?                    },},
        { key: "長考マン",           badge_params: { name: "🤯",   message: "考えすぎて負けがち",                 }, if_cond: proc { stat.overthinking_loss_stat.badge? } },
        # { key: "開幕千日手",         badge_params: { name: "❓",   message: "開幕千日手をした",                   }, if_cond: proc { stat.draw_stat.positive_rigging_count } },
        { key: "ただの千日手",       badge_params: { name: "🍌",   message: "千日手の使い手",                     }, if_cond: proc { stat.draw_stat.positive_normal_count } },
        { key: "運営支えマン",       badge_params: { name: "🧙‍♂️", message: "将棋ウォーズの運営を支える力がある", }, if_cond: proc { stat.fraud_stat.count.positive? } },

        ################################################################################ 対局モード x 対局ルール x 勝敗

        { key: "友対勝ち越しマン",   badge_params: { name: "🆚",   message: "友達対局で勝ち越した",               }, if_cond: proc { stat.xmode_judge_stat.strong_in_friends? } },
        { key: "指導受けマン",       badge_params: { name: "👨‍🎓", message: "指導対局を受けた",                   }, if_cond: proc { stat.xmode_stat.versus_pro? } },
        { key: "プロ越えマン",       badge_params: { name: "🦁",   message: "野生のプロ棋士",                     }, if_cond: proc { stat.pro_skill_exceed_stat.counts_hash[:win] } },
      ]
    end
  end
end
