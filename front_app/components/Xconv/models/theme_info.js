import MemoryRecord from 'js-memory-record'

export class ThemeInfo extends MemoryRecord {
  static get field_label() {
    return "テーマ"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "light_mode", name: "ライト", type: "is-primary", message: "明い", },
      { key: "dark_mode",  name: "ダーク", type: "is-primary", message: "暗い", },
    ]
  }
}
