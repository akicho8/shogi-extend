import MemoryRecord from 'js-memory-record'

export class DebugModeInfo extends MemoryRecord {
  static get field_label() {
    return "デバッグ"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "is_debug_mode_off", name: "OFF", type: "is-primary", message: null, },
      { key: "is_debug_mode_on",  name: "ON",  type: "is-danger",  message: null, },
    ]
  }
}
