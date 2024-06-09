# frozen-string-literal: true

module Swars
  module User::Stat
    class OtherInfo
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "テスト",
          local_only: true,
          body: proc {
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

        {
          key: "ids_count",
          local_only: true,
          body: proc { ids_count },
          chart_type: :simple,
          chart_options: {
          },
        },

        ################################################################################

        { key: "切断逃亡",                body: proc { judge_final_stat.count_by(:lose, :DISCONNECT) }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, },
        { key: "投了せずに放置",          body: proc { leave_alone_stat.positive_count               }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, },
        { key: "1手詰を焦らして悦に入る", body: proc { mate_stat.positive_count                      }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, },
        { key: "角不成",                  body: proc { tag_stat.counts_hash[:"角不成"]      }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, },
        { key: "飛車不成",                body: proc { tag_stat.counts_hash[:"飛車不成"]    }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, },
        { key: "無気力な対局",            body: proc { lethargy_stat.positive_count                  }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, },

        ################################################################################

        { key: "指導対局",         body: proc { xmode_judge_stat.to_chart(:"指導") },      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { "対局モード": "指導", },    }, },
        { key: "友達対局",         body: proc { xmode_judge_stat.to_chart(:"友達") },      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { "対局モード": "友達", },    }, },

        ################################################################################

        {
          key: "棋風",
          body: proc { rarity_stat.to_chart },
          chart_type: :pie,
          chart_options: {
            pie_type: :is_many_values,
          },
        },

        ################################################################################

        { key: "派閥",        body: proc { tag_stat.to_chart([:"居飛車", :"振り飛車"]) }, chart_type: :pie,             chart_options: { pie_type: :is_many_values,                                      },                 },
        { key: "居飛車",      body: proc { note_stat.to_chart("居飛車")               }, chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "居飛車"    }, }, },
        { key: "振り飛車",    body: proc { note_stat.to_chart("振り飛車")             }, chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "振り飛車", }, }, },
        { key: "相居飛車",    body: proc { note_stat.to_chart("相居飛車")             }, chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "相居飛車", }, }, },
        { key: "対振り",      body: proc { note_stat.to_chart("対振り")               }, chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "対振り",   }, }, },
        { key: "対抗形",      body: proc { note_stat.to_chart("対抗形")               }, chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "対抗形",   }, }, },
        { key: "相振り",      body: proc { note_stat.to_chart("相振り")               }, chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "相振り",   }, }, },

        ################################################################################

        { key: "連勝", chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "連勝", }, body: proc { win_lose_streak_stat.to_chart(:win)  }, },
        { key: "連敗", chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "連敗", }, body: proc { win_lose_streak_stat.to_chart(:lose) }, },

        ################################################################################

        { key: "大駒全ブッチ",     body: proc { note_stat.to_chart("大駒全ブッチ")     }, chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "大駒全ブッチ",     }, }, },
        { key: "大駒コンプリート", body: proc { note_stat.to_chart("大駒コンプリート") }, chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "大駒コンプリート", }, }, },
        { key: "入玉",             body: proc { note_stat.to_chart("入玉")             }, chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "入玉",             }, }, },

        ################################################################################

        { key: "棋風 (速度)", chart_type: :pie,             chart_options: { pie_type: :is_many_values,                                      },                 body: proc { tag_stat.to_chart([:"急戦", :"持久戦"])     }, },
        { key: "急戦",        chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "急戦",     }, }, body: proc { note_stat.to_chart("急戦")               }, },
        { key: "持久戦",      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "持久戦",   }, }, body: proc { note_stat.to_chart("持久戦")             }, },

        { key: "棋風 (手数)", chart_type: :pie,             chart_options: { pie_type: :is_many_values,                                      },                 body: proc { tag_stat.to_chart([:"短手数", :"長手数"])   }, },
        { key: "短手数",      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "短手数",   }, }, body: proc { note_stat.to_chart("短手数")             }, },
        { key: "長手数",      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_click_handle, with_search_params: { tag: "長手数",   }, }, body: proc { note_stat.to_chart("長手数")             }, },

        ################################################################################

        {
          key: "勝敗別平均手数",
          body: proc { average_moves_by_outcome_stat.to_chart },
          bottom_message: proc { average_moves_by_outcome_stat.bottom_message },
          chart_type: :pie,
          chart_options: { pie_type: :is_many_values, },
        },

        { key: "不屈の闘志", body: proc { mental_stat.level }, chart_type: :simple, chart_options: {}, },

        ################################################################################

        { key: "最長手数",         body: proc { turn_stat.max                             }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "手", }, },
        { key: "平均手数",         body: proc { turn_stat.average                         }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "手", }, },
        { key: "投了時の平均手数", body: proc { average_moves_at_resignation_stat.average }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "手", }, },

        ################################################################################

        { key: "投了せずに放置した時間 (最長)", body: proc { leave_alone_stat.max               }, chart_type: :simple, chart_options: { simple_type: :second,                        }, },
        { key: "投了せずに放置した頻度",        body: proc { leave_alone_stat.to_chart          }, chart_type: :pie,    chart_options: { pie_type: :is_many_values,                   }, },

        ################################################################################

        { key: "勝ち", body: proc { judge_final_stat.to_chart(:win) },  chart_type: :pie, chart_options: { pie_type: :is_many_values,}, },

        ################################################################################

        { key: "1手詰を焦らして悦に入った時間 (最長)", body: proc { mate_stat.max      }, chart_type: :simple, chart_options: { simple_type: :second,      }, },
        { key: "1手詰を焦らして悦に入った頻度",        body: proc { mate_stat.to_chart }, chart_type: :pie,    chart_options: { pie_type: :is_many_values, }, },

        ################################################################################

        { key:"負け", body: proc { judge_final_stat.to_chart(:lose) }, chart_type: :pie, chart_options: { pie_type: :is_many_values, }, },

        ################################################################################

        { key: "投了までの心の準備",        body: proc { resignation_stat.to_chart }, chart_type: :pie,    chart_options: { pie_type: :is_many_values, }, },
        { key: "投了までの心の準備 (平均)", body: proc { resignation_stat.average      }, chart_type: :simple, chart_options: { simple_type: :second,      }, },
        { key: "投了までの心の準備 (最長)", body: proc { resignation_stat.max          }, chart_type: :simple, chart_options: { simple_type: :second,      }, },

        ################################################################################

        {
          key: "最長考",
          chart_type: :simple,
          chart_options: {
            simple_type: :second,
          },
          body: proc { think_stat.max },
        },

        {
          key: "平均思考",
          chart_type: :simple,
          chart_options: {
            simple_type: :second,
          },
          body: proc { think_stat.average },
        },

        {
          key: "詰ます速度 (1手平均)",
          chart_type: :simple,
          chart_options: {
            simple_type: :second,
          },
          body: proc { mate_speed_stat.average },
        },

        {
          key: "駒の使用率",
          chart_type: :bar,
          chart_options: {
            bar_type: :is_default,
            tategaki_p: true,
            value_format: :percentage,
          },
          body: proc { piece_stat.to_chart },
        },

        {
          key: "対戦相手との段級差 (平均)",
          chart_type: :simple,
          chart_options: {
            simple_type: :raw,
          },
          body: proc { gdiff_stat.average },
        },

        ################################################################################

        { key: "ルール別対局頻度", body: proc { rule_stat.to_chart  }, chart_type: :pie, chart_options: { pie_type: :is_many_values, }, },
        { key: "対局モード",       body: proc { xmode_stat.to_chart }, chart_type: :pie, chart_options: { pie_type: :is_many_values, }, },

        ################################################################################

        { key: "1日の平均対局数", body: proc { daily_average_matches_stat.average }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "局", }, },
        { key: "1日の最高対局数", body: proc { daily_average_matches_stat.max     }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "局", }, },
        { key: "対局時間帯",      body: proc { match_time_period_stat.to_chart    }, chart_type: :bar,    chart_options: { bar_type: :is_default, }, },

        ################################################################################

        {
          key: "右玉度",
          chart_type: :pie,
          chart_options: {
            pie_type: :is_pair_values,
          },
          body: proc { right_king_stat.to_ratio_chart },
        },

        {
          key: "右玉ファミリー",
          chart_type: :pie,
          chart_options: {
            pie_type: :is_many_values,
          },
          body: proc { right_king_stat.to_names_chart },
        },

        ################################################################################

        {
          key: "将棋ウォーズの運営を支える力",
          chart_type: :pie,
          chart_options: {
            pie_type: :is_pair_values,
          },
          body: proc { fraud_stat.to_chart },
        },
      ]
    end
  end
end
