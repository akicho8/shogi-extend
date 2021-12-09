import { ParamBase } from '@/components/models/param_base.js'
import { Gs } from '@/components/models/gs.js'
import { ColumnInfo } from './column_info.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "remember_vs_user_keys", type: "array",   name: "対戦相手の補完リスト", defaults: { development: null, production: [],                        }, permanent: true,  relation: null,          desc: null, },
      { key: "display_key",           type: "string",  name: "局面表示タイプ",       defaults: { development: null, production: "critical",                }, permanent: true,  relation: "DisplayInfo", desc: null, },
      { key: "visible_hash",          type: "hash",    name: "カラム表示",           defaults: { development: null, production: this.visible_hash_default, }, permanent: true,  relation: null,          desc: null, },
    ]
  }

  static get visible_hash_default() {
    return Gs.as_visible_hash(ColumnInfo.values)
  }
}
