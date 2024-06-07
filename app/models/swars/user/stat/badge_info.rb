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
        { key: "角不成マン",         badge_params: { name: "☠",    message: "角不成で舐めプした",                      }, if_cond: proc { all_tag.exist?(:"角不成") }  },
        { key: "飛車不成マン",       badge_params: { name: "💀",   message: "飛車不成で舐めプした",                    }, if_cond: proc { all_tag.exist?(:"飛車不成") }  },

        ################################################################################

        { key: "居飛車党",           badge_params: { name: "⬆️",    message: "居飛車党",                           }, if_cond: proc { win_tag.group_ibis?                  },},
        { key: "振り飛車党",         badge_params: { name: "⬅️",    message: "振り飛車党",                         }, if_cond: proc { win_tag.group_furi?                  },},
        { key: "オールラウンダー",   badge_params: { name: "🅰",    message: "オールラウンダー",                   }, if_cond: proc { win_tag.group_all_rounder?               },},

        { key: "急戦マン",           badge_params: { name: "🐝",    message: "急戦で勝ち越した",                   }, if_cond: proc { stat.rapid_attack_stat.badge? },},

        { key: "三間飛車マン",       badge_params: { name: "3⃣",    message: "三間飛車で勝った",                   }, if_cond: proc { win_tag.to_s.match?(/三間|石田/) },},
        { key: "四間飛車マン",       badge_params: { name: "4⃣",    message: "四間飛車で勝った",                   }, if_cond: proc { win_tag.to_s.match?(/(?<!右)四間飛車/) },},
        { key: "九間飛車マン",       badge_params: { name: "9⃣",    message: "九間飛車で勝った",                   }, if_cond: proc { win_tag.to_s.include?("九間飛車") }, },
        { key: "中飛車マン",         badge_params: { name: "🀄",   message: "中飛車で勝った",                     }, if_cond: proc { win_tag.to_s.include?("中飛車")                  },},
        { key: "右四間飛車マン",     badge_params: { name: "⚔",    message: "右四間飛車で勝った",                 }, if_cond: proc { win_tag.to_s.include?("右四間") }, },
        { key: "袖飛車マン",         badge_params: { name: "👘",   message: "袖飛車で勝った",                     }, if_cond: proc { win_tag.exist?(:"袖飛車")                   },},
        { key: "一間飛車マン",       badge_params: { name: "1️⃣",    message: "一間飛車で勝った",                   }, if_cond: proc { win_tag.to_s.include?("一間飛車") }, },
        { key: "嬉野マン",           badge_params: { name: "↗️",    message: "嬉野流で勝った",                     }, if_cond: proc { win_tag.to_s.include?("嬉野流") },},
        { key: "パックマン野郎",     badge_params: { name: "🅿",    message: "パックマンで勝った",                 }, if_cond: proc { win_tag.to_s.include?("パックマン") },},
        { key: "耀龍マン",           badge_params: { name: "🐉",   message: "耀龍戦法で勝った",                   }, if_cond: proc { win_tag.to_s.include?("耀龍") }, },
        { key: "右玉マン",           badge_params: { name: "➡",    message: "右玉で勝った",                       }, if_cond: proc { win_tag.to_s.include?("右玉") }, },
        { key: "ロケットマン",       badge_params: { name: "🚀",   message: "ロケットで勝った",                   }, if_cond: proc { win_tag.exist?(:"ロケット")                  },},
        { key: "遠見の角マン",       badge_params: { name: "🔭",   message: "遠見の角で勝った",                   }, if_cond: proc { win_tag.exist?(:"遠見の角")                  },},
        { key: "屋敷マン",           badge_params: { name: "🥷",   message: "屋敷流二枚銀で勝った",               }, if_cond: proc { win_tag.to_s.include?("屋敷流二枚銀") },},
        { key: "UFOマン",            badge_params: { name: "🛸",   message: "UFO銀で勝った",                      }, if_cond: proc { win_tag.exist?(:"UFO銀")                   },},
        { key: "カニ執着マン",       badge_params: { name: "🦀",   message: "カニ系戦法で勝った",                 }, if_cond: proc { win_tag.to_s.include?("カニ") },},
        { key: "カメレオンマン",     badge_params: { name: "🦎",   message: "カメレオン系戦法で勝った",           }, if_cond: proc { win_tag.to_s.include?("カメレオン") },},
        { key: "ポンポンマン",       badge_params: { name: "🦗",   message: "ポンポン桂で勝った",                 }, if_cond: proc { win_tag.exist?(:"ポンポン桂")                  },},
        { key: "穴熊マン",           badge_params: { name: "🐻",   message: "穴熊で勝った",                       }, if_cond: proc { win_tag.to_s.include?("熊")                  },},
        { key: "ダイヤマン",         badge_params: { name: "💎",   message: "ダイヤモンド美濃で勝った",           }, if_cond: proc { win_tag.exist?(:"ダイヤモンド美濃")                 },},
        { key: "チョコレートマン",   badge_params: { name: "🍫",   message: "チョコレート囲いで勝った",           }, if_cond: proc { win_tag.exist?(:"チョコレート囲い")                 },},
        { key: "幽霊角マン",         badge_params: { name: "👻",   message: "幽霊角で勝った",                     }, if_cond: proc { win_tag.exist?(:"幽霊角")                   },},
        { key: "極限早繰りマン",     badge_params: { name: "🏃🏻", message: "極限早繰り銀で勝った",               }, if_cond: proc { win_tag.exist?(:"極限早繰り銀")                  },},
        { key: "坊主マン",           badge_params: { name: "👴🏻", message: "坊主美濃で勝った",                   }, if_cond: proc { win_tag.exist?(:"坊主美濃")                  },},
        { key: "レグスペマン",       badge_params: { name: "🐔",   message: "レグスペで勝った",                   }, if_cond: proc { win_tag.exist?(:"レグスペ")                  },},
        { key: "音無しマン",         badge_params: { name: "🦉",   message: "居飛穴音無しの構えで勝った",         }, if_cond: proc { win_tag.exist?(:"居飛穴音無しの構え")                 },},
        { key: "筋違い角マン",       badge_params: { name: "👨🏻", message: "筋違い角おじさん",                   }, if_cond: proc { all_tag.exist?(:"筋違い角")                   },},
        { key: "スイーツマン",       badge_params: { name: "🍓",   message: "いちご囲いで勝った",                 }, if_cond: proc { win_tag.exist?(:"いちご囲い")                  },},
        { key: "無敵囲いマン",       badge_params: { name: "🔰",   message: "無敵囲いで勝った",                   }, if_cond: proc { win_tag.exist?(:"無敵囲い")                  },},
        { key: "背水マン",           badge_params: { name: "🧠",   message: "大駒全部捨てて勝った",               }, if_cond: proc { win_tag.exist?(:"背水の陣")                  },},
        { key: "エルモマン",         badge_params: { name: "🐒",   message: "エルモ囲いで勝った",                 }, if_cond: proc { win_tag.exist?(:"エルモ囲い")                  },},
        { key: "小部屋マン",         badge_params: { name: "🛖",   message: "銀冠の小部屋の使い手",               }, if_cond: proc { win_tag.exist?(:"銀冠の小部屋")                  },},
        { key: "鬼殺しマン",         badge_params: { name: "👹",   message: "鬼殺しで勝った",                     }, if_cond: proc { win_tag.to_s.include?("鬼殺し") },},
        { key: "アヒルマン",         badge_params: { name: "🐥",   message: "アヒル戦法で勝った",                 }, if_cond: proc { win_tag.exist?(:"アヒル戦法") },},
        { key: "稲庭マン",           badge_params: { name: "👾",   message: "稲庭戦法で勝った",                   }, if_cond: proc { win_tag.exist?(:"稲庭戦法") },},
        { key: "パンツマン",         badge_params: { name: "🩲",   message: "パンツを脱いで勝った",               }, if_cond: proc { win_tag.exist?(:"パンツを脱ぐ") }, },
        { key: "居玉勝ちマン",       badge_params: { name: "🗿",   message: "居玉で勝った",                       }, if_cond: proc { win_tag.exist?(:"居玉") }, },
        { key: "入玉勝ちマン",       badge_params: { name: "🏈",   message: "入玉で勝った",                       }, if_cond: proc { win_tag.exist?(:"入玉") }, },
        { key: "都詰めマン",         badge_params: { name: "🏯",   message: "都詰めで勝った",                      }, if_cond: proc { win_tag.exist?(:"都詰め") }  },
        { key: "駒柱マン",           badge_params: { name: "🗽",   message: "駒柱を作って勝った",                  }, if_cond: proc { win_tag.exist?(:"駒柱") }  },

        #############################################             ###################################

        { key: "10連勝",             badge_params: { name: "💮",   message: "10連勝した",                         }, if_cond: proc { win_lose_streak_stat.ten_win? },},
        { key: "10連敗",             badge_params: { name: "⛈",    message: "10連敗した",                         }, if_cond: proc { win_lose_streak_stat.ten_lose? },},
        { key: "波が激しいマン",     badge_params: { name: "🌊",   message: "勝ち負けの波が激しい",               }, if_cond: proc { win_lose_streak_stat.waves_strong? },},

        #############################################             ###################################

        { key: "200手越えマン",      badge_params: { name: "⚡️",    message: "200手以上で勝った",                  }, if_cond: proc { (stat.win_turn_stat.max || 0) >= 200 },},
        { key: "心強すぎマン",       badge_params: { name: "🫀",   message: "折れない心の持ち主",                 }, if_cond: proc { stat.mental_stat.hard_brain? },},
        { key: "廃指しマン",         badge_params: { name: "😡",   message: "廃指し名人",                         }, if_cond: proc { (stat.daily_average_matches_stat.max || 0) >= 30 },},

        { key: "投了マン",           badge_params: { name: "🙇‍♂️", message: "負けるときは必ず投了する",            }, if_cond: proc { (stat.judge_final_stat.ratio_by(:lose, :TORYO) || 0) >= 1.0 }, },
        { key: "切れ負けマン",       badge_params: { name: "⌛",   message: "切れ負けが多い",                      }, if_cond: proc { (stat.judge_final_stat.ratio_by(:lose, :TIMEOUT) || 0) >= 0.25 },},
        { key: "レア戦法マン",       badge_params: { name: "🍀",   message: "変態戦法の使い手",                   }, if_cond: proc { stat.rarity_stat.minority?                    },},
        { key: "長考マン",           badge_params: { name: "🤯",   message: "考えすぎて負けがち",                 }, if_cond: proc { stat.overthinking_loss_stat.badge? } },
        { key: "開幕千日手",         badge_params: { name: "❓",   message: "開幕千日手をした",                   }, if_cond: proc { (stat.perpetual_check_stat.opening_repetition_move_count || 0).positive? } },
        { key: "ただの千日手",       badge_params: { name: "🍌",   message: "千日手の使い手",                     }, if_cond: proc { (stat.perpetual_check_stat.over50_draw_count || 0).positive? } },
        { key: "友対勝ちマン",       badge_params: { name: "🆚",   message: "友達対局で勝った",                   }, if_cond: proc { stat.xmode_judge_stat.exist?(:"友達", :win) } },
        { key: "指導受けマン",       badge_params: { name: "🔥",   message: "指導対局で負けた",                   }, if_cond: proc { stat.xmode_judge_stat.exist?(:"指導", :lose) } },
        { key: "プロ越えマン",       badge_params: { name: "💪",   message: "指導対局で勝った",                   }, if_cond: proc { stat.xmode_judge_stat.exist?(:"指導", :win) } },
        { key: "運営支えマン",       badge_params: { name: "🧙‍♂️", message: "将棋ウォーズの運営を支える力がある", }, if_cond: proc { stat.fraud_stat.count.positive? } },
      ]
    end
  end
end
