import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "user_key",                            type: "string",  name: "ウォーズID",   defaults: { development: null, production: "",       }, permanent: true, relation: null,              desc: null, },
      { key: "xmode_key",                           type: "string",  name: "対局モード",   defaults: { development: null, production: "none",   }, permanent: true, relation: "ChoiceXmodeInfo", desc: null, },
      { key: "final_key",                           type: "string",  name: "結果",         defaults: { development: null, production: "すべて", }, permanent: true, relation: "ChoiceFinalInfo", desc: null, },
      { key: "judge_key",                           type: "string",  name: "勝敗",         defaults: { development: null, production: "none",   }, permanent: true, relation: "ChoiceJudgeInfo", desc: null, },

      { key: "critical_turn_enabled",               type: "boolean", name: "開戦有効",     defaults: { development: null, production: false,    }, permanent: true,  relation: null,             desc: null, },
      { key: "critical_turn",                       type: "integer", name: "開戦",         defaults: { development: null, production: 30,       }, permanent: true,  relation: null,             desc: null, },
      { key: "critical_turn_compare",               type: "string",  name: "開戦演算子",   defaults: { development: null, production: "lteq",   }, permanent: true,  relation: null,             desc: null, },

      { key: "outbreak_turn_enabled",               type: "boolean", name: "中盤有効",     defaults: { development: null, production: false,    }, permanent: true,  relation: null,             desc: null, },
      { key: "outbreak_turn",                       type: "integer", name: "中盤",         defaults: { development: null, production: 40,       }, permanent: true,  relation: null,             desc: null, },
      { key: "outbreak_turn_compare",               type: "string",  name: "中盤演算子",   defaults: { development: null, production: "lteq",   }, permanent: true,  relation: null,             desc: null, },

      { key: "turn_max_enabled",                    type: "boolean", name: "手数有効",     defaults: { development: null, production: false,    }, permanent: true,  relation: null,             desc: null, },
      { key: "turn_max",                            type: "integer", name: "手数",         defaults: { development: null, production: 100,       }, permanent: true,  relation: null,             desc: null, },
      { key: "turn_max_compare",                    type: "string",  name: "手数演算子",   defaults: { development: null, production: "gteq",   }, permanent: true,  relation: null,             desc: null, },

      { key: "grade_diff",                          type: "integer", name: "力差",         defaults: { development: null, production: 0,       }, permanent: true,  relation: null,             desc: null, },
      { key: "grade_diff_enabled",                  type: "boolean", name: "力差有効",     defaults: { development: null, production: false,    }, permanent: true,  relation: null,             desc: null, },
      { key: "grade_diff_compare",                  type: "string",  name: "力差演算子",   defaults: { development: null, production: "gteq",   }, permanent: true,  relation: null,             desc: null, },

      // { key: "tiresome_previous_user_key",       type: "string",  name: "前回入力の対象ユーザー", defaults: { development: null, production: "",                        }, permanent: true,  relation: null,                            desc: null, },
      // { key: "turn_max",                         type: "integer", name: "自力入力回数",           defaults: { development: null, production: 0,                         }, permanent: true,  relation: null,                            desc: null, },
      // { key: "tiresome_modal_selected",          type: "string",  name: "誘導モーダル選択値",     defaults: { development: null, production: "none",                    }, permanent: true,  relation: null,                            desc: null, },
      // { key: "remember_vs_user_keys",            type: "array",   name: "対戦相手",               defaults: { development: null, production: [],                        }, permanent: true,  relation: null,                            desc: null, },
      // { key: "complement_user_keys",             type: "array",   name: "入力履歴",               defaults: { development: null, production: [],                        }, permanent: true,  relation: null,                            desc: null, },
      // { key: "complement_user_keys_size_max",    type: "array",   name: "入力履歴の最大",         defaults: { development: 3,    production: 100,                       }, permanent: false, relation: null,                            desc: null, },
      // { key: "complement_user_keys_prepend_key", type: "string",  name: "入力履歴に取り込む種類", defaults: { development: null, production: "query",                   }, permanent: false, relation: "ComplementUserKeysPrependInfo", desc: null, },
      // { key: "visible_hash",                     type: "hash",    name: "表示カラム",             defaults: { development: null, production: this.visible_hash_default, }, permanent: true,  relation: null,                            desc: null, },
    ]
  }
}
