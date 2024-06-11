require "./setup"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => 
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => 
# ~> <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require': --> /Users/ikeda/src/shogi-extend/app/models/swars/user/stat/badge_info.rb
# ~> Unmatched `(', missing `)' ?
# ~>     6  module Swars
# ~>     7    module User::Stat
# ~>     8      class BadgeInfo
# ~>    12        memory_record [
# ~> >  15          { key: "切断マン",           badge_params: { name: "💩",   message: "切断の使い手",                            }, if_cond: proc { (stat.judge_final_stat.count_by(:lose, :DISCONNECT) || 0).positive? },},
# ~> >  16          { key: "絶対投了しないマン", badge_params: { name: "🪳",   message: "悔しかったので時間切れまで放置した",      }, if_cond: proc { stat.leave_alone_stat.count.positive? } },
# ~> >  17          { key: "無気力マン",         badge_params: { name: "🦥",   message: "無気力な対局をした",                      }, if_cond: proc { stat.lethargy_stat.exist? } },
# ~> >  18          { key: "大長考マン",         badge_params: { name: "😴",   message: "対局放棄と受け取られかねない長考をした",  }, if_cond: proc { stat.prolonged_deliberation_stat.count.positive? } },
# ~> >  19          { key: "1手詰じらしマン",    badge_params: { name: "😈",   message: "1手詰を焦らして歪んだ優越感に浸った",     }, if_cond: proc { stat.mate_stat.count.positive? } },
# ~> >  20          { key: "相手退席待ちマン",   badge_params: { name: "🪰",   message: AITETAISEKIMATMAN_MESSAGE,                 }, if_cond: proc { stat.waiting_to_leave_stat.count.positive? } },
# ~> >  21          { key: "角不成マン",         badge_params: { name: "☠",    message: "角不成で舐めプした",                    }, if_cond: proc { stat.tag_stat.counts_hash.has_key?(:"角不成") }  },
# ~> >  22          { key: "飛車不成マン",       badge_params: { name: "💀",   message: "飛車不成で舐めプした",                   }, if_cond: proc { stat.tag_stat.counts_hash.has_key?(:"飛車不成") }  },
# ~> >  26          { key: "居飛車党",           badge_params: { name: "⬆️",     message: "真の居飛車党",         }, if_cond: proc { win_stat.the_ture_master_of_ibis? },},
# ~> >  27          { key: "振り飛車党",         badge_params: { name: "⬅️",    message: "真の振り飛車党",       }, if_cond: proc { win_stat.the_ture_master_of_furi? },},
# ~> >  28          { key: "オールラウンダー",   badge_params: { name: "🅰",    message: "真のオールラウンダー", }, if_cond: proc { win_stat.the_ture_master_of_all_rounder? },},
# ~> >  32          { key: "三間飛車マン",   badge_params: { name: "3⃣", message: "三間飛車の匠",          }, if_cond: proc { win_stat.match?(/三間|石田/) },},
# ~> >  33          { key: "四間飛車マン",   badge_params: { name: "4⃣", message: "四間飛車の匠",          }, if_cond: proc { win_stat.match?(/(?<!右)四間飛車/) },},
# ~> >  34          { key: "九間飛車マン",   badge_params: { name: "9⃣", message: "九間飛車のパイオニア",  }, if_cond: proc { win_stat.include?("九間飛車") }, },
# ~> >  35          { key: "中飛車マン",     badge_params: { name: "🀄",   message: "中飛車名人",            }, if_cond: proc { win_stat.include?("中飛車") },},
# ~> >  36          { key: "右四間飛車マン", badge_params: { name: "⚔",    message: "右四間飛車の破壊神",    }, if_cond: proc { win_stat.include?("右四間") }, },
# ~> >  37          { key: "袖飛車マン",     badge_params: { name: "👘",   message: "袖飛車の奇人",          }, if_cond: proc { win_stat.exist?(:"袖飛車") },},
# ~> >  38          { key: "一間飛車マン",   badge_params: { name: "1️⃣",    message: "一間飛車の異端児",      }, if_cond: proc { win_stat.include?("一間飛車") }, },
# ~> >  42          { key: "ロケットマン",       badge_params: { name: "🚀",   message: "ロケットの名手",             }, if_cond: proc { win_stat.exist?(:"ロケット") },},
# ~> >  43          { key: "金底マン",           badge_params: { name: "🪨",   message: "金底の歩の名手",             }, if_cond: proc { win_stat.exist?(:"金底の歩") },},
# ~> >  44          { key: "遠見の角マン",       badge_params: { name: "🔭",   message: "遠見の角の名手",             }, if_cond: proc { win_stat.exist?(:"遠見の角") },},
# ~> >  45          { key: "幽霊角マン",         badge_params: { name: "👻",   message: "幽霊角の名手",               }, if_cond: proc { win_stat.exist?(:"幽霊角")                   },},
# ~> >  49          { key: "嬉野マン",           badge_params: { name: "↗️",    message: "嬉野流の使い手",             }, if_cond: proc { win_stat.include?("嬉野流") },},
# ~> >  50          { key: "パックマン野郎",     badge_params: { name: "🅿",    message: "パックマンの達人",          }, if_cond: proc { win_stat.include?("パックマン") },},
# ~> >  51          { key: "耀龍マン",           badge_params: { name: "🐉",   message: "耀龍戦法の使い手",           }, if_cond: proc { win_stat.include?("耀龍") }, },
# ~> >  52          { key: "右玉マン",           badge_params: { name: "➡",    message: "右玉の匠",                  }, if_cond: proc { win_stat.include?("右玉") }, },
# ~> >  53          { key: "屋敷マン",           badge_params: { name: "🥷",   message: "屋敷流二枚銀の使い手",       }, if_cond: proc { win_stat.include?("屋敷流二枚銀") },},
# ~> >  54          { key: "UFOマン",            badge_params: { name: "🛸",   message: "UFO銀の使い手",              }, if_cond: proc { win_stat.exist?(:"UFO銀") },},
# ~> >  55          { key: "カニ執着マン",       badge_params: { name: "🦀",   message: "カニ系戦法の使い手",         }, if_cond: proc { win_stat.include?("カニ") },},
# ~> >  56          { key: "カメレオンマン",     badge_params: { name: "🦎",   message: "カメレオン系戦法の使い手",   }, if_cond: proc { win_stat.include?("カメレオン") },},
# ~> >  57          { key: "ポンポンマン",       badge_params: { name: "🦗",   message: "ポンポン桂の使い手",         }, if_cond: proc { win_stat.exist?(:"ポンポン桂") },},
# ~> >  58          { key: "穴熊マン",           badge_params: { name: "🐻",   message: "穴熊名人",                   }, if_cond: proc { win_stat.include?("熊") },},
# ~> >  59          { key: "ダイヤマン",         badge_params: { name: "💎",   message: "ダイヤモンド美濃の使い手",   }, if_cond: proc { win_stat.exist?(:"ダイヤモンド美濃")                 },},
# ~> >  60          { key: "チョコレートマン",   badge_params: { name: "🍫",   message: "チョコレート囲いの使い手",   }, if_cond: proc { win_stat.exist?(:"チョコレート囲い")                 },},
# ~> >  61          { key: "極限早繰りマン",     badge_params: { name: "🏃🏻", message: "極限早繰り銀の使い手",       }, if_cond: proc { win_stat.exist?(:"極限早繰り銀")                  },},
# ~> >  62          { key: "坊主マン",           badge_params: { name: "👴🏻", message: "坊主美濃の使い手",           }, if_cond: proc { win_stat.exist?(:"坊主美濃")                  },},
# ~> >  63          { key: "レグスペマン",       badge_params: { name: "🐔",   message: "レグスペの使い手",           }, if_cond: proc { win_stat.exist?(:"レグスペ")                  },},
# ~> >  64          { key: "音無しマン",         badge_params: { name: "🦉",   message: "居飛穴音無しの構えの使い手", }, if_cond: proc { win_stat.exist?(:"居飛穴音無しの構え")                 },},
# ~> >  65          { key: "スイーツマン",       badge_params: { name: "🍓",   message: "いちご囲いの使い手",         }, if_cond: proc { win_stat.exist?(:"いちご囲い")                  },},
# ~> >  66          { key: "無敵囲いマン",       badge_params: { name: "🔰",   message: "無敵囲いのスペシャリスト",    }, if_cond: proc { win_stat.exist?(:"無敵囲い")                  },},
# ~> >  67          { key: "エルモマン",         badge_params: { name: "🐒",   message: "エルモ囲いの使い手",         }, if_cond: proc { win_stat.exist?(:"エルモ囲い")                  },},
# ~> >  68          { key: "鬼殺しマン",         badge_params: { name: "👹",   message: "鬼殺しの使い手",             }, if_cond: proc { win_stat.include?("鬼殺し") },},
# ~> >  69          { key: "アヒルマン",         badge_params: { name: "🐥",   message: "アヒル戦法の名匠",           }, if_cond: proc { win_stat.exist?(:"アヒル戦法") },},
# ~> >  70          { key: "稲庭マン",           badge_params: { name: "👾",   message: "稲庭戦法のエキスパート",     }, if_cond: proc { win_stat.exist?(:"稲庭戦法") },},
# ~> >  71          { key: "居玉勝ちマン",       badge_params: { name: "🗿",   message: "居玉の達人",                 }, if_cond: proc { win_stat.exist?(:"居玉") }, },
# ~> >  72          { key: "入玉勝ちマン",       badge_params: { name: "🏈",   message: "入玉の達人",                 }, if_cond: proc { win_stat.exist?(:"入玉") }, },
# ~> >  76          { key: "駒柱マン",           badge_params: { name: "🗽",   message: "駒柱の作り手",               }, if_cond: proc { win_stat.exist?(:"駒柱") }  },
# ~> >  77          { key: "パンツマン",         badge_params: { name: "🩲",   message: "パンツを脱いだ",             }, if_cond: proc { win_stat.exist?(:"パンツを脱ぐ") }, },
# ~> >  78          { key: "小部屋マン",         badge_params: { name: "🛖",   message: "銀冠の小部屋を活用した",     }, if_cond: proc { win_stat.exist?(:"銀冠の小部屋") },},
# ~> >  79          { key: "都詰めマン",         badge_params: { name: "🏯",   message: "都詰めマスター (超レア)",    }, if_cond: proc { win_stat.exist?(:"都詰め") } },
# ~> >  80          { key: "ブッチマン",         badge_params: { name: "🧠",   message: "大駒全ブッチの達人",         }, if_cond: proc { win_stat.exist?(:"大駒全ブッチ") },},
# ~> >  81          { key: "筋違い角マン",       badge_params: { name: "👨🏻", message: "筋違い角おじさん",           }, if_cond: proc { win_stat.exist?(:"筋違い角") },},
# ~> >  85          { key: "急戦マン",           badge_params: { name: "🐝",    message: "急戦のエキスパート",                 }, if_cond: proc { stat.rapid_attack_stat.badge?              },},
# ~> >  89          { key: "10連勝",             badge_params: { name: "💮",   message: "10連勝した",                         }, if_cond: proc { win_lose_streak_stat.ten_win? },},
# ~> >  90          { key: "10連敗",             badge_params: { name: "⛈",    message: "連敗名人",                           }, if_cond: proc { win_lose_streak_stat.ten_lose? },},
# ~> >  91          { key: "波が激しいマン",     badge_params: { name: "🌊",   message: "勝ち負けの波が激しい",               }, if_cond: proc { win_lose_streak_stat.waves_strong? },},
# ~> >  95          { key: "200手越えマン",      badge_params: { name: "⚡️",    message: "200手以上で勝った",                  }, if_cond: proc { (stat.win_turn_stat.max || 0) >= 200 },},
# ~> >  96          { key: "心強すぎマン",       badge_params: { name: "🫀",   message: "折れない心の持ち主",                 }, if_cond: proc { stat.mental_stat.hard_brain? },},
# ~> >  97          { key: "廃指しマン",         badge_params: { name: "😡",   message: "感情的になって廃指しした",           }, if_cond: proc { (stat.daily_average_matches_stat.max || 0) >= 30 },},
# ~> >  99          { key: "投了マン",           badge_params: { name: "🙇‍♂️", message: "投了を究めた",                       }, if_cond: proc { (stat.judge_final_stat.toryo_master? }, },
# ~> > 100          { key: "切れ負けマン",       badge_params: { name: "⌛",   message: "切れ負けの常連",                     }, if_cond: proc { (stat.judge_final_stat.ratio_by(:lose, :TIMEOUT) || 0) >= 0.25 },},
# ~> > 101          { key: "レア戦法マン",       badge_params: { name: "🍀",   message: "変態戦法の匠",                       }, if_cond: proc { stat.rarity_stat.minority?                    },},
# ~> > 102          { key: "長考マン",           badge_params: { name: "🤯",   message: "考えすぎて負けがち",                 }, if_cond: proc { stat.overthinking_loss_stat.badge? } },
# ~> > 103          { key: "開幕千日手",         badge_params: { name: "❓",   message: "開幕千日手をした",                   }, if_cond: proc { stat.draw_stat.positive_rigging_count } },
# ~> > 104          { key: "ただの千日手",       badge_params: { name: "🍌",   message: "千日手の使い手",                     }, if_cond: proc { stat.draw_stat.positive_normal_count } },
# ~> > 105          { key: "運営支えマン",       badge_params: { name: "🧙‍♂️", message: "将棋ウォーズの運営を支える力がある", }, if_cond: proc { stat.fraud_stat.count.positive? } },
# ~> > 109          { key: "友対勝ち越しマン",   badge_params: { name: "🆚",   message: "友達対局で勝ち越した",               }, if_cond: proc { stat.xmode_judge_stat.strong_in_friends? } },
# ~> > 110          { key: "指導受けマン",       badge_params: { name: "🔥",   message: "指導対局を受けた",                   }, if_cond: proc { stat.xmode_stat.exist?(:"指導") } },
# ~> > 111          { key: "プロ越えマン",       badge_params: { name: "🦁",   message: "野生のプロ棋士",                     }, if_cond: proc { stat.pro_skill_exceed_stat.counts_hash[:win] } },
# ~>   112        ]
# ~>   113      end
# ~>   114    end
# ~>   115  end
# ~> /Users/ikeda/src/shogi-extend/app/models/swars/user/stat/badge_info.rb:99: syntax error, unexpected '}', expecting ')' (SyntaxError)
# ~> ...udge_final_stat.toryo_master? }, },
# ~> ...                              ^
# ~> /Users/ikeda/src/shogi-extend/app/models/swars/user/stat/badge_info.rb:100: syntax error, unexpected ')', expecting '}'
# ~> ...ratio_by(:lose, :TIMEOUT) || 0) >= 0.25 },},
# ~> ...                              ^
# ~> 
# ~> 	from <internal:/opt/rbenv/versions/3.2.2/lib/ruby/site_ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bootsnap-1.16.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/zeitwerk-2.6.15/lib/zeitwerk/kernel.rb:26:in `require'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/user/stat/badge_stat.rb:24:in `active_badges'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/user/stat/badge_stat.rb:19:in `as_json'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/user/stat/main.rb:54:in `to_header_h'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/user/stat/main.rb:37:in `block in to_hash'
# ~> 	from <internal:kernel>:90:in `tap'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/swars/user/stat/main.rb:29:in `to_hash'
# ~> 	from -:2:in `block in <main>'
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `block (2 levels) in _'
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `times'
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `block in _'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/3.2.0/benchmark.rb:311:in `realtime'
# ~> 	from /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-7.1.2/lib/active_support/core_ext/benchmark.rb:14:in `ms'
# ~> 	from /Users/ikeda/src/shogi-extend/workbench/setup.rb:5:in `_'
# ~> 	from -:2:in `<main>'
