# frozen-string-literal: true

module Swars
  module User::Stat
    class PenaltyInfo
      include ApplicationMemoryRecord
      memory_record [
        { weight:  20.0, key: "友達対局で無双した",               short_name: "友達対局無双",   x_count: proc { xmode_judge_stat.friend_kill_ratio                           }, },
        { weight:   0.4, key: "時間切れで負けた回数",             short_name: "切れ負け",       x_count: proc { judge_final_stat.count_by(:lose, :TIMEOUT)                   }, },
        { weight:   0.2, key: "詰まされて負けた回数",             short_name: "詰み負け",       x_count: proc { judge_final_stat.count_by(:lose, :CHECKMATE)                 }, },
        { weight:   0.8, key: "敗勢になると諦める度合い",         short_name: "敗勢諦め",       x_count: proc { mental_stat.heart_weak_level                                 }, },
        { weight:   0.4, key: "無理攻めをした",                   short_name: "無理攻め",       x_count: proc { tag_stat.muriseme_level                                      }, },
        { weight:   8.0, key: "連続王手の千日手をして負けた",     short_name: "連続王手",       x_count: proc { judge_final_stat.count_by(:lose, :OUTE_SENNICHI)             }, },
        { weight:   2.0, key: "先手なのに千日手で逃げた回数",     short_name: "先手千日手",     x_count: proc { draw_stat.black_sennichi_count                               }, },
        { weight:   1.0, key: "舐めプ戦法を使った対局数",         short_name: "舐めプ戦法",     x_count: proc { bad_tactic_stat.bad_tactic_count                             }, },
        { weight:  10.0, key: "指し手が異様に速い",               short_name: "指し手速い",     x_count: proc { think_stat.unusually_fast_ratio                              }, },
        { weight:   5.0, key: "指し手が異様に遅い",               short_name: "指し手遅い",     x_count: proc { think_stat.unusually_slow_ratio                              }, },
        { weight:   3.0, key: "無気力な対局の回数",               short_name: "無気力",         x_count: proc { lethargy_stat.count                                          }, },
        { weight:   6.0, key: "わざと負けて棋力調整",             short_name: "棋力調整",       x_count: proc { skill_adjust_stat.count                                         }, },
        { weight:   4.0, key: "角不成をした対局数",               short_name: "角不成",         x_count: proc { tag_stat.count_by(:"角不成")                                 }, },
        { weight:   8.0, key: "飛車不成をした対局数",             short_name: "飛車不成",       x_count: proc { tag_stat.count_by(:"飛車不成")                               }, },
        { weight:  15.0, key: "1手詰を焦らした対局数",            short_name: "1手詰焦らし",    x_count: proc { taunt_mate_stat.count                                        }, },
        { weight:  20.0, key: "必勝形から焦らした対局数",         short_name: "勝ち焦らし",     x_count: proc { taunt_timeout_stat.count                                     }, },
        { weight:  10.0, key: "人に対して棋神を使った対局数",     short_name: "棋神",           x_count: proc { fraud_stat.count                                             }, },
        { weight:   3.0, key: "恐怖の級位者として振る舞った",     short_name: "逆棋力詐欺(強)", x_count: proc { gdiff_stat.row_grade_pretend_count                           }, },
        { weight:   5.0, key: "適正な棋力帯で対局しなかった",     short_name: "棋力詐欺(弱)",   x_count: proc { user.grade_info.teacher ? 0 : gdiff_stat.grade_penalty_ratio }, },
        { weight:   5.0, key: "対局放棄のような長考をした対局数", short_name: "対局放棄長考",   x_count: proc { prolonged_deliberation_stat.count                            }, },
        { weight:  10.0, key: "切断逃亡",                         short_name: "切断逃亡",       x_count: proc { judge_final_stat.count_by(:lose, :DISCONNECT)                }, },
        { weight:  15.0, key: "放置",                             short_name: "放置",           x_count: proc { leave_alone_stat.count                                       }, },
        { weight:  20.0, key: "退席待ち狙いをした回数",           short_name: "退席待ち狙い",   x_count: proc { waiting_to_leave_stat.count                                  }, },
        { weight:   5.0, key: "通信環境が不安定なのに対局",           short_name: "悪環境",         x_count: proc { unstable_network_stat.count                                      }, },
      ]
    end
  end
end
