# frozen-string-literal: true

module Swars
  module User::Stat
    class OtherInfo
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "テスト",
          local_only: true,
          body: -> {
            [
              { name: "a", value: 1 },
              { name: "b", value: 2 },
              { name: "c", value: 3 },
              { name: "d", value: 4 },
              { name: "e", value: 5 },
            ]
          },
          chart_type: :pie,
          chart_options: {
            pie_type: :is_many_values,
          },
        },

        { key: "time format",       local_only: true, body: -> { 100                                        }, chart_type: :simple, chart_options: { simple_type: :second,                        }, with_search: { params: nil, key: nil } },
        { key: "count format",      local_only: true, body: -> { 100                                        }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: nil }, },

        ################################################################################

        { key: "ids_count",         local_only: true, body: -> { ids_count                                  }, chart_type: :simple, chart_options: {}, },
        { key: "win / lose / draw", local_only: true, body: -> { [win_count, lose_count, draw_count] * ", " }, chart_type: :simple, chart_options: {}, },

        ################################################################################

        { key: "指導対局でプロに平手で勝った", body: -> { !user.grade_info.teacher && pro_skill_exceed_stat.counts_hash[:win] }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: ProSkillExceedStat.search_params, }, },

        ################################################################################

        { key: "行動規範", local_only: false, body: -> { gentleman_stat.final_score.try { floor } }, chart_type: :simple, chart_options: { zero_allow: true, simple_type: :numeric_with_unit, unit: "点", }, },

        ################################################################################

        { key: "切断逃亡",                         local_only: false, body: -> { judge_final_stat.count_by(:lose, :DISCONNECT) }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: { "結末" => "切断", "勝敗" => "負け", "手数" => [">=", Config.establish_gteq].join }, }, },
        { key: "通信環境が不安定なのに対局",       local_only: false, body: -> { unstable_network_stat.count                   }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: UnstableNetworkStat.search_params, }, },
        { key: "逆棋力詐欺",                       local_only: false, body: -> { gdiff_stat.row_grade_pretend_count            }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: GdiffStat.search_params, }, },
        { key: "投了せずに放置",                   local_only: false, body: -> { leave_alone_stat.count                        }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: LeaveAloneStat.search_params, }, },

        { key: "放置で離席させ逆時間切れ勝ち狙い", local_only: false, body: -> { waiting_to_leave_stat.count                   }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: WaitingToLeaveStat.search_params, }, },
        { key: "対局放棄と受け取られかねない長考", local_only: false, body: -> { prolonged_deliberation_stat.count             }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: ProlongedDeliberationStat.search_params, }, },
        { key: "1手詰を焦らして悦に入った",        local_only: false, body: -> { taunt_mate_stat.count                         }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: TauntMateStat.search_params, }, },
        { key: "必勝形から焦らして悦に入った",     local_only: false, body: -> { taunt_timeout_stat.count                      }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: TauntTimeoutStat.search_params, }, },
        { key: "無気力な対局",                     local_only: false, body: -> { lethargy_stat.count                           }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: LethargyStat.search_params, }, },
        { key: "わざと負けて棋力調整",             local_only: false, body: -> { skill_adjust_stat.count                       }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: SkillAdjustStat.search_params, }, },
        { key: "角不成",                           local_only: false, body: -> { tag_stat.counts_hash[:"角不成"]               }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: { tag: "角不成", } }, },
        { key: "飛車不成",                         local_only: false, body: -> { tag_stat.counts_hash[:"飛車不成"]             }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: { tag: "飛車不成", } }, },
        { key: "全駒",                             local_only: false, body: -> { tag_stat.counts_hash[:"全駒"]                 }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: { tag: "全駒", } }, },
        { key: "玉単騎",                           local_only: false, body: -> { tag_stat.counts_hash[:"玉単騎"]               }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: { tag: "玉単騎", } }, },
        { key: "先手なのに千日手",                 local_only: false, body: -> { draw_stat.black_sennichi_count                }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, with_search: { params: DrawStat.search_params } },

        ################################################################################

        { key: "勢い",             body: -> { vitality_stat.vital_ratio.then { |e| (e * 100.0).round } }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "%", }, with_search: {} },

        ################################################################################

        { key: "友達対局",         body: -> { xmode_judge_stat.to_chart(:"友達")      }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { "対局モード": "友達", },    }, },
        { key: "指導対局",         body: -> { xmode_judge_stat.to_chart(:"指導")      }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { "対局モード": "指導", },    }, },
        { key: "指導対局 (平手)",  body: -> { pro_skill_exceed_stat.to_win_lose_chart }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { "対局モード": "指導", "手合割": "平手" }, }, },

        ################################################################################

        { key: "棋風", body: -> { style_stat.to_chart }, chart_type: :pie, chart_options: { pie_type: :is_many_values, }, with_search: { key: "棋風" }, },

        ################################################################################

        { key: "派閥",        local_only: false, body: -> { tag_stat.to_pie_chart([:"居飛車", :"振り飛車"])        }, chart_type: :pie,             chart_options: { pie_type: :is_many_values, }, with_search: { key: "tag" }, },
        { key: "居飛車",      local_only: false, body: -> { tag_stat.to_win_lose_chart(:"居飛車")                  }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "居飛車"    }, }, },
        { key: "振り飛車",    local_only: false, body: -> { tag_stat.to_win_lose_chart(:"振り飛車")                }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "振り飛車", }, }, },
        { key: "相居飛車",    local_only: false, body: -> { tag_stat.to_win_lose_chart(:"相居飛車")                }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "相居飛車", }, }, },
        { key: "対居飛車",    local_only: true,  body: -> { tag_stat.to_win_lose_chart(:"対居飛車")                }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "対居飛車", }, }, },
        { key: "vs 居飛車",   local_only: false, body: -> { op_tag_stat.to_win_lose_chart(:"居飛車", swap: true)   }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { "vs-tag": "居飛車", }, }, },
        { key: "対振り飛車",  local_only: true,  body: -> { tag_stat.to_win_lose_chart(:"対振り飛車")                  }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "対振り飛車",   }, }, },
        { key: "vs 振り飛車", local_only: false, body: -> { op_tag_stat.to_win_lose_chart(:"振り飛車", swap: true) }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { "vs-tag": "振り飛車", }, }, },
        { key: "対抗形",      local_only: false, body: -> { tag_stat.to_win_lose_chart(:"対抗形")                  }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "対抗形",   }, }, },
        { key: "相振り飛車",  local_only: false, body: -> { tag_stat.to_win_lose_chart(:"相振り飛車")                  }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "相振り飛車",   }, }, },
        { key: "相居玉",      local_only: false, body: -> { tag_stat.to_win_lose_chart(:"相居玉")                  }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "相居玉",   }, }, },

        ################################################################################

        { key: "連勝", chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "連勝", }, body: -> { win_lose_streak_stat.max(:win)  }, },
        { key: "連敗", chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "連敗", }, body: -> { win_lose_streak_stat.max(:lose) }, },

        ################################################################################

        { key: "大駒全ブッチ",        local_only: true, body: -> { tag_stat.to_win_lose_chart(:"大駒全ブッチ")                    }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "大駒全ブッチ",     }, }, },
        { key: "大駒コンプリート",    local_only: true, body: -> { tag_stat.to_win_lose_chart(:"大駒コンプリート")                }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "大駒コンプリート", }, }, },

        # 「大駒全ブッチ」と「vs 大駒コンプリート」の勝敗数は同等になるため両方を表示する意味がない
        { key: "vs 大駒全ブッチ",     local_only: true,  body: -> { op_tag_stat.to_win_lose_chart(:"大駒全ブッチ", swap: true)     }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { "vs-tag": "大駒全ブッチ", }, }, },
        { key: "vs 大駒コンプリート", local_only: true,  body: -> { op_tag_stat.to_win_lose_chart(:"大駒コンプリート", swap: true) }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { "vs-tag": "大駒コンプリート", }, }, },

        ################################################################################

        { key: "[win-lose] 角不成",      display_name: "角不成",      local_only: true, body: -> { tag_stat.to_win_lose_chart(:"角不成")                    }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "角不成",     }, }, },
        { key: "[win-lose] vs 角不成",   display_name: "vs 角不成",   local_only: true, body: -> { op_tag_stat.to_win_lose_chart(:"角不成", swap: true)     }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { "vs-tag": "角不成", }, }, },
        { key: "[win-lose] 飛車不成",    display_name: "飛車不成",    local_only: true, body: -> { tag_stat.to_win_lose_chart(:"飛車不成")                    }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "飛車不成",     }, }, },
        { key: "[win-lose] vs 飛車不成", display_name: "vs 飛車不成", local_only: true, body: -> { op_tag_stat.to_win_lose_chart(:"飛車不成", swap: true)     }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { "vs-tag": "飛車不成", }, }, },

        ################################################################################

        ################################################################################

        { key: "[win-lose] 入玉",    display_name: "入玉",    local_only: true, body: -> { tag_stat.to_win_lose_chart(:"入玉")                    }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "入玉",     }, }, },
        { key: "[win-lose] vs 入玉", display_name: "vs 入玉", local_only: true, body: -> { op_tag_stat.to_win_lose_chart(:"入玉", swap: true)     }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { "vs-tag": "入玉", }, }, },

        ################################################################################

        # { key: "入玉",             body: -> { tag_stat.to_win_lose_chart(:"入玉")             }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "入玉",             }, }, },
        # { key: "垂れ歩",           body: -> { tag_stat.to_win_lose_chart(:"垂れ歩")           }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "垂れ歩",           }, }, },
        # { key: "金底の歩",         body: -> { tag_stat.to_win_lose_chart(:"金底の歩")         }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "金底の歩",         }, }, },
        # { key: "割り打ちの銀",     body: -> { tag_stat.to_win_lose_chart(:"割り打ちの銀")     }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "割り打ちの銀",     }, }, },
        # { key: "腹銀",             body: -> { tag_stat.to_win_lose_chart(:"腹銀")             }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "腹銀",             }, }, },
        # { key: "継ぎ桂",           body: -> { tag_stat.to_win_lose_chart(:"継ぎ桂")           }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "継ぎ桂",           }, }, },
        # { key: "桂頭の銀",         body: -> { tag_stat.to_win_lose_chart(:"桂頭の銀")         }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "桂頭の銀",         }, }, },

        ################################################################################

        { key: "棋風 (速度)", body: -> { tag_stat.to_pie_chart([:"急戦", :"持久戦"])       }, chart_type: :pie,             chart_options: { pie_type: :is_many_values, }, with_search: { key: "tag" }, },
        { key: "急戦",        body: -> { tag_stat.to_win_lose_chart(:"急戦")               }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "急戦",     }, }, },
        { key: "持久戦",      body: -> { tag_stat.to_win_lose_chart(:"持久戦")             }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "持久戦",   }, }, },

        { key: "棋風 (手数)", body: -> { tag_stat.to_pie_chart([:"短手数", :"長手数"])     }, chart_type: :pie,             chart_options: { pie_type: :is_many_values, }, with_search: { key: "tag" }, },
        { key: "短手数",      body: -> { tag_stat.to_win_lose_chart(:"短手数")             }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "短手数",   }, }, },
        { key: "長手数",      body: -> { tag_stat.to_win_lose_chart(:"長手数")             }, chart_type: :win_lose_circle, chart_options: {}, with_search: { params: { tag: "長手数",   }, }, },

        ################################################################################

        {
          key: "勝敗別平均手数",
          body: -> { average_moves_by_outcome_stat.to_chart },
          chart_type: :pie,
          chart_options: { pie_type: :is_many_values, },
          with_search: { key: "勝敗" },
        },

        { key: "不屈の闘志", body: -> { mental_stat.level }, chart_type: :simple, chart_options: {}, },

        ################################################################################

        { key: "最長手数",         body: -> { turn_stat.max                             }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "手", }, with_search: { params: { sort_column: "turn_max", sort_order: "desc" }, }, },
        { key: "平均手数",         body: -> { turn_stat.average                         }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "手", }, },
        { key: "投了時の平均手数", body: -> { average_moves_at_resignation_stat.average }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "手", }, },

        ################################################################################

        { key: "投了せずに放置した時間 (最長)", body: -> { leave_alone_stat.max               }, chart_type: :simple, chart_options: { simple_type: :second,                        }, with_search: { params: LeaveAloneStat.search_params_max } },
        { key: "投了せずに放置した頻度",        body: -> { leave_alone_stat.to_chart          }, chart_type: :pie,    chart_options: { pie_type: :is_many_values,                   }, },

        ################################################################################

        { key: "勝ち", body: -> { judge_final_stat.to_chart(:win) },  chart_type: :pie, chart_options: { pie_type: :is_many_values, }, with_search: { params: { "勝敗" => "勝ち" }, key: "結末", }, },

        ################################################################################

        { key: "1手詰を焦らして悦に入った時間 (最長)", body: -> { taunt_mate_stat.max      }, chart_type: :simple, chart_options: { simple_type: :second,      }, with_search: { params: TauntMateStat.search_params_max } },
        { key: "1手詰を焦らして悦に入った頻度",        body: -> { taunt_mate_stat.to_chart }, chart_type: :pie,    chart_options: { pie_type: :is_many_values, }, },

        { key: "必勝形から焦らして悦に入った時間 (最長)", body: -> { taunt_timeout_stat.max      }, chart_type: :simple, chart_options: { simple_type: :second,      }, with_search: { params: TauntTimeoutStat.search_params_max } },
        { key: "必勝形から焦らして悦に入った頻度",        body: -> { taunt_timeout_stat.to_chart }, chart_type: :pie,    chart_options: { pie_type: :is_many_values, }, },

        ################################################################################

        { key: "負け", body: -> { judge_final_stat.to_chart(:lose) }, chart_type: :pie, chart_options: { pie_type: :is_many_values, }, with_search: { params: { "勝敗" => "負け" }, key: "結末", }, },

        ################################################################################

        { key: "投了までの心の準備",        body: -> { resignation_stat.to_chart }, chart_type: :pie,    chart_options: { pie_type: :is_many_values, }, },
        { key: "投了までの心の準備 (最長)", body: -> { resignation_stat.max          }, chart_type: :simple, chart_options: { simple_type: :second,      }, with_search: { params: ResignationStat.search_params_max } },
        { key: "投了までの心の準備 (平均)", body: -> { resignation_stat.average      }, chart_type: :simple, chart_options: { simple_type: :second,      }, },

        ################################################################################

        { key: "最長考",   body: -> { think_stat.max                      }, chart_type: :simple, chart_options: { simple_type: :second, }, with_search: { params: ThinkStat.search_params_max } },
        { key: "平均思考", body: -> { think_stat.average.try { round(2) } }, chart_type: :simple, chart_options: { simple_type: :second, }, },

        {
          key: "詰ます速度 (1手平均)",
          chart_type: :simple,
          chart_options: {
            simple_type: :second,
          },

          body: -> { mate_speed_stat.average },
        },

        ################################################################################

        {
          key: "駒の使用率",
          chart_type: :bar,
          chart_options: {
            bar_type: :is_default,
            tategaki_p: true,
            value_format: :percentage,
          },
          body: -> { piece_stat.to_chart },
        },

        {
          key: "対戦相手との段級差 (平均)",
          body: -> { gdiff_stat.average.try { round(2) } },
          chart_type: :simple,
          chart_options: {
            zero_allow: true,
            simple_type: :raw,
          },
          with_search: { params: GdiffStat.search_params_sort },
        },

        ################################################################################

        { key: "時間別対局頻度", body: -> { rule_stat.to_chart  }, chart_type: :pie, chart_options: { pie_type: :is_many_values, }, },
        { key: "対局モード",       body: -> { xmode_stat.to_chart }, chart_type: :pie, chart_options: { pie_type: :is_many_values, }, },

        ################################################################################

        { key: "1日の平均対局数", body: -> { daily_average_matches_stat.average }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "局", }, },
        { key: "1日の最高対局数", body: -> { daily_average_matches_stat.max     }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "局", }, },
        { key: "対局曜日",        body: -> { battle_time_wday_stat.to_chart     }, chart_type: :bar,    chart_options: { bar_type: :is_default, value_format: :percentage, }, },
        { key: "対局時間帯",      body: -> { battle_time_hour_stat.to_chart     }, chart_type: :bar,    chart_options: { bar_type: :is_default, }, },

        ################################################################################

        # {
        #   key: "右玉度",
        #   chart_type: :pie,
        #   chart_options: {
        #     pie_type: :is_pair_values,
        #   },
        #   body: -> { right_king_stat.to_ratio_chart },
        # },
        #
        # {
        #   key: "右玉ファミリー",
        #   body: -> { right_king_stat.to_names_chart },
        #   chart_type: :pie,
        #   chart_options: {
        #     pie_type: :is_many_values,
        #   },
        #   with_search: { key: "tag", },
        # },

        ################################################################################

        {
          key: "将棋ウォーズの運営を支える力",
          chart_type: :pie,
          chart_options: {
            pie_type: :is_pair_values,
          },
          body: -> { fraud_stat.to_chart },
        },
      ]

      def display_name
        super || name
      end

      def with_search
        super || {}
      end
    end
  end
end
