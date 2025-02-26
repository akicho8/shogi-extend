import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "user_key",                   type: "string",  name: "対象のウォーズID",                   defaults: { development: null, production: "",     }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },
      { key: "vs_user_keys",               type: "array",   name: "相手のウォーズIDs",                  defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "remember_vs_user_keys",      type: "array",   name: "相手のウォーズID入力履歴",           defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: false, resetable: true,  desc: null, },

      { key: "xmode_keys",                 type: "array",  name: "対局モード",                          defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "xmode2_keys",                type: "array",  name: "開始局面",                            defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "rule_keys",                  type: "array",  name: "持ち時間",                            defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "final_keys",                 type: "array",  name: "結果",                                defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "preset_keys",                type: "array",  name: "手合割",                              defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "judge_keys",                 type: "array",  name: "勝敗",                                defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "grade_keys",                 type: "array",  name: "棋力",                                defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "location_keys",              type: "array",  name: "先後",                                defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "ban_keys",                   type: "array",  name: "垢BAN",                               defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },

      { key: "battled_at_range",           type: "array",   name: "日付",                               defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },

      { key: "my_tag_values",              type: "array",   name: "自分タグ",                           defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "my_tag_values_op",           type: "string",  name: "自分タグ演算子",                     defaults: { development: null, production: "and",  }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "vs_tag_values",              type: "array",   name: "相手タグ",                           defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "vs_tag_values_op",           type: "string",  name: "相手タグ演算子",                     defaults: { development: null, production: "and",  }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },

      { key: "my_style_keys",              type: "array",  name: "自分の棋風",                          defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "vs_style_keys",              type: "array",  name: "相手の棋風",                          defaults: { development: null, production: [],     }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },

      { key: "critical_turn_enabled",      type: "boolean", name: "開戦有効",                           defaults: { development: null, production: false,  }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "critical_turn",              type: "integer", name: "開戦",                               defaults: { development: null, production: 40,     }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },
      { key: "critical_turn_compare",      type: "string",  name: "開戦演算子",                         defaults: { development: null, production: "lteq", }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },

      { key: "outbreak_turn_enabled",      type: "boolean", name: "中盤有効",                           defaults: { development: null, production: false,  }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "outbreak_turn",              type: "integer", name: "中盤",                               defaults: { development: null, production: 50,     }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },
      { key: "outbreak_turn_compare",      type: "string",  name: "中盤演算子",                         defaults: { development: null, production: "gteq", }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },

      { key: "turn_max_enabled",           type: "boolean", name: "手数有効",                           defaults: { development: null, production: false,  }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "turn_max",                   type: "integer", name: "手数",                               defaults: { development: null, production: 100,    }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },
      { key: "turn_max_compare",           type: "string",  name: "手数演算子",                         defaults: { development: null, production: "gteq", }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },

      { key: "my_think_max_enabled",       type: "boolean", name: "最大思考有効",                       defaults: { development: null, production: false,  }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "my_think_max",               type: "integer", name: "最大思考",                           defaults: { development: null, production: 3*60,   }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },
      { key: "my_think_max_compare",       type: "string",  name: "最大思考演算子",                     defaults: { development: null, production: "gteq", }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },

      { key: "my_think_avg_enabled",       type: "boolean", name: "平均思考有効",                       defaults: { development: null, production: false,  }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "my_think_avg",               type: "integer", name: "平均思考",                           defaults: { development: null, production: 10,     }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },
      { key: "my_think_avg_compare",       type: "string",  name: "平均思考演算子",                     defaults: { development: null, production: "lteq", }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },

      { key: "my_think_last_enabled",      type: "boolean", name: "最終思考有効",                       defaults: { development: null, production: false,  }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "my_think_last",              type: "integer", name: "最終思考",                           defaults: { development: null, production: 3*60,   }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },
      { key: "my_think_last_compare",      type: "string",  name: "最終思考演算子",                     defaults: { development: null, production: "gteq", }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },

      { key: "my_ai_wave_count_enabled",   type: "boolean", name: "棋神波形数有効",             defaults: { development: null, production: false,  }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "my_ai_wave_count",           type: "integer", name: "棋神波形数",                 defaults: { development: null, production: 10,     }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },
      { key: "my_ai_wave_count_compare",   type: "string",  name: "棋神波形数演算子",           defaults: { development: null, production: "lteq", }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },

      { key: "my_ai_drop_total_enabled", type: "boolean", name: "棋神を模倣した指し手の数有効",   defaults: { development: null, production: false,  }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "my_ai_drop_total",         type: "integer", name: "棋神を模倣した指し手の数",       defaults: { development: null, production: 10,     }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },
      { key: "my_ai_drop_total_compare", type: "string",  name: "棋神を模倣した指し手の数演算子", defaults: { development: null, production: "gteq", }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },

      { key: "grade_diff_enabled",         type: "boolean", name: "力差有効",                           defaults: { development: null, production: false,  }, permanent: true, relation: null, permalink: true, resetable: true,  desc: null, },
      { key: "grade_diff",                 type: "integer", name: "力差",                               defaults: { development: null, production: 1,      }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },
      { key: "grade_diff_compare",         type: "string",  name: "力差演算子",                         defaults: { development: null, production: "gteq", }, permanent: true, relation: null, permalink: true, resetable: false, desc: null, },
    ]
  }
}
