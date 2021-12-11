import { ParamBase } from '@/components/models/param_base.js'
import { Gs } from '@/components/models/gs.js'
import { ColumnInfo } from './column_info.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "layout_key",            type: "string",  name: "レイアウト", defaults: { development: null, production: "is_layout_table",         }, permanent: true,  relation: "LayoutInfo",  desc: null, },
      { key: "scene_key",             type: "string",  name: "局面",       defaults: { development: null, production: "critical",                }, permanent: true,  relation: "SceneInfo",   desc: null, },
      { key: "per_key",               type: "string",  name: "件数",       defaults: { development: null, production: "is_per10",                }, permanent: true,  relation: "PerInfo",     desc: null, },
      { key: "remember_vs_user_keys", type: "array",   name: "対戦相手",   defaults: { development: null, production: [],                        }, permanent: true,  relation: null,          desc: null, },
      { key: "visible_hash",          type: "hash",    name: "表示カラム", defaults: { development: null, production: this.visible_hash_default, }, permanent: true,  relation: null,          desc: null, },
    ]
  }

  static get visible_hash_default() {
    return Gs.as_visible_hash(ColumnInfo.values)
  }
}
