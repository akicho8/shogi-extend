import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "user_key",              type: "string",  name: "ウォーズID",     defaults: { development: null, production: "",     }, permanent: true, relation: null, desc: null, },

      { key: "xmode_keys",            type: "string",  name: "対局モード",     defaults: { development: null, production: [],     }, permanent: true, relation: null, desc: null, },
      { key: "rule_keys",             type: "string",  name: "持ち時間",       defaults: { development: null, production: [],     }, permanent: true, relation: null, desc: null, },
      { key: "final_keys",            type: "string",  name: "結果",           defaults: { development: null, production: [],     }, permanent: true, relation: null, desc: null, },
      { key: "preset_keys",           type: "string",  name: "手合割",         defaults: { development: null, production: [],     }, permanent: true, relation: null, desc: null, },
      { key: "judge_keys",            type: "string",  name: "勝敗",           defaults: { development: null, production: [],     }, permanent: true, relation: null, desc: null, },
      { key: "grade_keys",            type: "string",  name: "棋力",           defaults: { development: null, production: [],     }, permanent: true, relation: null, desc: null, },
      { key: "location_keys",         type: "string",  name: "先後",           defaults: { development: null, production: [],     }, permanent: true, relation: null, desc: null, },

      { key: "my_tag_values",         type: "array",   name: "自分タグ",       defaults: { development: null, production: [],     }, permanent: true, relation: null, desc: null, },
      { key: "my_tag_values_op",      type: "string",  name: "自分タグ演算子", defaults: { development: null, production: "and",  }, permanent: true, relation: null, desc: null, },
      { key: "vs_tag_values",         type: "array",   name: "相手タグ",       defaults: { development: null, production: [],     }, permanent: true, relation: null, desc: null, },
      { key: "vs_tag_values_op",      type: "string",  name: "相手タグ演算子", defaults: { development: null, production: "and",  }, permanent: true, relation: null, desc: null, },

      { key: "critical_turn_enabled", type: "boolean", name: "開戦有効",       defaults: { development: null, production: false,  }, permanent: true, relation: null, desc: null, },
      { key: "critical_turn",         type: "integer", name: "開戦",           defaults: { development: null, production: 30,     }, permanent: true, relation: null, desc: null, },
      { key: "critical_turn_compare", type: "string",  name: "開戦演算子",     defaults: { development: null, production: "lteq", }, permanent: true, relation: null, desc: null, },

      { key: "outbreak_turn_enabled", type: "boolean", name: "中盤有効",       defaults: { development: null, production: false,  }, permanent: true, relation: null, desc: null, },
      { key: "outbreak_turn",         type: "integer", name: "中盤",           defaults: { development: null, production: 40,     }, permanent: true, relation: null, desc: null, },
      { key: "outbreak_turn_compare", type: "string",  name: "中盤演算子",     defaults: { development: null, production: "lteq", }, permanent: true, relation: null, desc: null, },

      { key: "turn_max_enabled",      type: "boolean", name: "手数有効",       defaults: { development: null, production: false,  }, permanent: true, relation: null, desc: null, },
      { key: "turn_max",              type: "integer", name: "手数",           defaults: { development: null, production: 100,    }, permanent: true, relation: null, desc: null, },
      { key: "turn_max_compare",      type: "string",  name: "手数演算子",     defaults: { development: null, production: "gteq", }, permanent: true, relation: null, desc: null, },

      { key: "grade_diff_enabled",    type: "boolean", name: "力差有効",       defaults: { development: null, production: false,  }, permanent: true, relation: null, desc: null, },
      { key: "grade_diff",            type: "integer", name: "力差",           defaults: { development: null, production: 1,      }, permanent: true, relation: null, desc: null, },
      { key: "grade_diff_compare",    type: "string",  name: "力差演算子",     defaults: { development: null, production: "gteq", }, permanent: true, relation: null, desc: null, },
    ]
  }
}
