import MemoryRecord from 'js-memory-record'

export class LoopInfo extends MemoryRecord {
  static get field_label() {
    return "ループ"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "false", name: "しない", type: "is-primary", message: "", },
      { key: "true",  name: "する",   type: "is-primary", message: "", },
    ]
  }
}
