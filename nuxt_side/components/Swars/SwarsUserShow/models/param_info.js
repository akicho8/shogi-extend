import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "tab_index",  type: "integer", name: "タブ",     defaults: { development: null, production: 0,  }, permanent: true, relation: null, desc: null, },
      { key: "sample_max", type: "integer", name: "件数",     defaults: { development: null, production: 50, }, permanent: true, relation: null, desc: null, },
      { key: "rule",       type: "string",  name: "持ち時間", defaults: { development: null, production: "", }, permanent: true, relation: null, desc: null, },
      { key: "xmode",      type: "string",  name: "モード",   defaults: { development: null, production: "", }, permanent: true, relation: null, desc: null, },
    ]
  }
}
