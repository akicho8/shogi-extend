import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "column_size_code", type: "integer", name: "サイズ",              default: 1,   permanent: true,   relation: "ColumnSizeInfo", desc: "",           },
      { key: "per",              type: "integer", name: "1ページのアイテム数", default: 108, permanent: false,  relation: null,             desc: "",           },
      { key: "page",             type: "integer", name: "ページ",              default: 1,   permanent: false,  relation: null,             desc: "",           },
    ]
  }
}
