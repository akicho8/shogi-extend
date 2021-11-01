import { ParamBase } from '@/components/models/param_base.js'

export class ParamInfo extends ParamBase {
  static get define() {
    return [
      { key: "tap_detect_key", type: "string", name: "クリック反応", default: "pointerdown", permanent: true, relation: "TapDetectInfo", desc: "", },
    ]
  }
}
