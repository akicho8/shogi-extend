import MemoryRecord from 'js-memory-record'

export class ParamInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "tap_detect_key", type: "string", name: "クリック反応", default: "pointerdown", permanent: true, relation: "TapDetectInfo", desc: "", },
    ]
  }
}
