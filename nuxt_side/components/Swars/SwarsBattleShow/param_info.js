import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "time_chart_variant_key", type: "string",  name: "チャートの種類", defaults: { development: null, production: "tcv_normal",  }, permanent: true, relation: "TimeChartVariantInfo", desc: null, },
      { key: "time_chart_zoom_key",    type: "string",  name: "拡縮の状態",     defaults: { development: null, production: "zoom_minus",  }, permanent: true, relation: "TimeChartZoomInfo",             desc: null, },
    ]
  }
}
