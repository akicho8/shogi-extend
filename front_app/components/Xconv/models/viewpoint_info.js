import MemoryRecord from 'js-memory-record'

export class ViewpointInfo extends MemoryRecord {
  static get field_label() {
    return "視点"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "black", name: "☗ 先手", type: "is-primary", message: null, },
      { key: "white", name: "☖ 後手", type: "is-primary", message: null, },
    ]
  }
}
