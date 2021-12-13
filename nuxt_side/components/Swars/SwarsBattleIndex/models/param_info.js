import { ParamBase } from '@/components/models/param_base.js'
import { Gs } from '@/components/models/gs.js'
import { ColumnInfo } from './column_info.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "tiresome_previous_user_key",       type: "string",  name: "前回入力の対象ユーザー", defaults: { development: null, production: "",                        }, permanent: true,  relation: null,                            desc: null, },
      { key: "tiresome_count",                   type: "integer", name: "自力入力回数",           defaults: { development: null, production: 0,                         }, permanent: true,  relation: null,                            desc: null, },
      { key: "tiresome_modal_selected",          type: "string",  name: "誘導モーダル選択値",     defaults: { development: null, production: "none",                    }, permanent: true,  relation: null,                            desc: null, },
      { key: "layout_key",                       type: "string",  name: "レイアウト",             defaults: { development: null, production: "is_layout_table",         }, permanent: true,  relation: "LayoutInfo",                    desc: null, },
      { key: "scene_key",                        type: "string",  name: "局面",                   defaults: { development: null, production: "critical_turn",           }, permanent: true,  relation: "SceneInfo",                     desc: null, },
      { key: "per_key",                          type: "string",  name: "件数",                   defaults: { development: null, production: "is_per10",                }, permanent: true,  relation: "PerInfo",                       desc: null, },
      { key: "remember_vs_user_keys",            type: "array",   name: "対戦相手",               defaults: { development: null, production: [],                        }, permanent: true,  relation: null,                            desc: null, },
      { key: "complement_user_keys",             type: "array",   name: "入力履歴",               defaults: { development: null, production: [],                        }, permanent: true,  relation: null,                            desc: null, },
      { key: "complement_user_keys_size_max",    type: "array",   name: "入力履歴の最大",         defaults: { development: 3,    production: 100,                       }, permanent: false, relation: null,                            desc: null, },
      { key: "complement_user_keys_prepend_key", type: "string",  name: "入力履歴に取り込む種類", defaults: { development: null, production: "query",                   }, permanent: false, relation: "ComplementUserKeysPrependInfo", desc: null, },
      { key: "visible_hash",                     type: "hash",    name: "表示カラム",             defaults: { development: null, production: this.visible_hash_default, }, permanent: true,  relation: null,                            desc: null, },
    ]
  }

  static get visible_hash_default() {
    return Gs.as_visible_hash(ColumnInfo.values)
  }
}
