import MemoryRecord from 'js-memory-record'

export class DebugInfo extends MemoryRecord {
  static get field_label() {
    return "デバッグ"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "is_debug_off", name: "OFF", type: "is-primary", message: null, },
      { key: "is_debug_on",  name: "ON",  type: "is-danger",  message: null, },
    ]
  }
}
