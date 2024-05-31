# frozen-string-literal: true

module Swars
  module UserStat
    class EtcInfo
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

        {
          key: "切断逃亡",
          body: proc { rage_stat.positive_count },
          chart_type: :simple,
          chart_options: {
            simple_type: :numeric_with_unit,
            unit: "回",
          },
        },

        ################################################################################

        { key: "角不成",   body: proc { all_tag.to_h[:"角不成"]   }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, },
        { key: "飛車不成", body: proc { all_tag.to_h[:"飛車不成"] }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, },

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

        { key: "派閥",        chart_type: :pie,             chart_options: { pie_type: :is_many_values,                                      }, body: proc { all_tag.to_chart([:"居飛車", :"振り飛車"]) }, },
        { key: "居飛車",      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_with_tag_click_handle, tag: "居飛車"    }, body: proc { note_stat.to_chart("居飛車")             }, },
        { key: "振り飛車",    chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_with_tag_click_handle, tag: "振り飛車", }, body: proc { note_stat.to_chart("振り飛車")           }, },
        { key: "相居飛車",    chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_with_tag_click_handle, tag: "相居飛車", }, body: proc { note_stat.to_chart("相居飛車")           }, },
        { key: "対振り",      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_with_tag_click_handle, tag: "対振り",   }, body: proc { note_stat.to_chart("対振り")             }, },
        { key: "対抗形",      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_with_tag_click_handle, tag: "対抗形",   }, body: proc { note_stat.to_chart("対抗形")             }, },
        { key: "相振り",      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_with_tag_click_handle, tag: "相振り",   }, body: proc { note_stat.to_chart("相振り")             }, },

        { key: "棋風 (速度)", chart_type: :pie,             chart_options: { pie_type: :is_many_values,                                      }, body: proc { all_tag.to_chart([:"急戦", :"持久戦"])     }, },
        { key: "急戦",        chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_with_tag_click_handle, tag: "急戦",     }, body: proc { note_stat.to_chart("急戦")               }, },
        { key: "持久戦",      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_with_tag_click_handle, tag: "持久戦",   }, body: proc { note_stat.to_chart("持久戦")             }, },

        { key: "棋風 (手数)", chart_type: :pie,             chart_options: { pie_type: :is_many_values,                                      }, body: proc { all_tag.to_chart([:"短手数", :"長手数"])   }, },
        { key: "短手数",      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_with_tag_click_handle, tag: "短手数",   }, body: proc { note_stat.to_chart("短手数")             }, },
        { key: "長手数",      chart_type: :win_lose_circle, chart_options: { click_method: :win_lose_with_tag_click_handle, tag: "長手数",   }, body: proc { note_stat.to_chart("長手数")             }, },

        ################################################################################

        { key: "ルール別対局頻度", body: proc { rule_stat.to_chart  }, chart_type: :pie, chart_options: { pie_type: :is_many_values, }, },
        { key: "対局モード",       body: proc { xmode_stat.to_chart }, chart_type: :pie, chart_options: { pie_type: :is_many_values, }, },

        ################################################################################

        { key: "連勝", chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "連勝", }, body: proc { streak_stat.to_chart(:win)  }, },
        { key: "連敗", chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "連敗", }, body: proc { streak_stat.to_chart(:lose) }, },

        ################################################################################

        {
          key: "勝敗別平均手数",
          body: proc { tavg_stat.to_chart },
          bottom_message: proc { tavg_stat.bottom_message },
          chart_type: :pie,
          chart_options: {
            pie_type: :is_many_values,
          },
        },

        {
          key: "不屈の闘志",
          chart_type: :simple,
          chart_options: {},
          body: proc { mental_stat.level },
        },

        { key: "平均手数",       body: proc { turn_stat.average     },           chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "手", }, },
        { key: "最長手数",       body: proc { turn_stat.max         },           chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "手", }, },

        {
          key: "投了時の平均手数",
          chart_type: :simple,
          chart_options: {
            simple_type: :numeric_with_unit,
            unit: "手",
          },
          body: proc { ttavg_stat.average },
        },

        { key: "投了せずに放置した回数",        body: proc { houti_stat.positive_count    }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回", }, },
        { key: "投了せずに放置した時間 (最長)", body: proc { houti_stat.max               }, chart_type: :simple, chart_options: { simple_type: :second,                        }, },
        { key: "投了せずに放置した頻度",        body: proc { houti_stat.to_chart          }, chart_type: :pie,    chart_options: { pie_type: :is_many_values,                   }, },

        { key: "1日の平均対局数", body: proc { bpd_stat.average }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "局", }, },

        {
          key: "対局時間帯",
          chart_type: :bar,
          chart_options: {
            bar_type: :is_default,
          },
          body: proc { tzone_stat.to_chart },
        },

        {
          key: "勝ち",
          chart_type: :pie,
          chart_options: {
            pie_type: :is_many_values,
          },
          body: proc { final_stat.to_chart(:win) },
        },

        ################################################################################

        { key: "1手詰を焦らして悦に入った回数",        body: proc { mate_stat.positive_count }, chart_type: :simple, chart_options: { simple_type: :numeric_with_unit, unit: "回" }, },
        { key: "1手詰を焦らして悦に入った時間 (最長)", body: proc { mate_stat.max            }, chart_type: :simple, chart_options: { simple_type: :second,      }, },
        { key: "1手詰を焦らして悦に入った頻度",        body: proc { mate_stat.to_chart   }, chart_type: :pie,    chart_options: { pie_type: :is_many_values, }, },

        ################################################################################

        {
          key: "負け",
          chart_type: :pie,
          chart_options: {
            pie_type: :is_many_values,
          },
          body: proc { final_stat.to_chart(:lose) },
        },

        ################################################################################

        { key: "投了までの心の準備",        body: proc { toryo_stat.to_chart }, chart_type: :pie,    chart_options: { pie_type: :is_many_values, }, },
        { key: "投了までの心の準備 (平均)", body: proc { toryo_stat.average      }, chart_type: :simple, chart_options: { simple_type: :second,      }, },
        { key: "投了までの心の準備 (最長)", body: proc { toryo_stat.max          }, chart_type: :simple, chart_options: { simple_type: :second,      }, },

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
          body: proc { mspeed_stat.average },
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

        {
          key: "右玉度",
          chart_type: :pie,
          chart_options: {
            pie_type: :is_pair_values,
          },
          body: proc { migi_stat.to_ratio_chart },
        },

        {
          key: "右玉ファミリー",
          chart_type: :pie,
          chart_options: {
            pie_type: :is_many_values,
          },
          body: proc { migi_stat.to_names_chart },
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
