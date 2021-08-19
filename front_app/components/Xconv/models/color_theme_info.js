import MemoryRecord from 'js-memory-record'

export class ColorThemeInfo extends MemoryRecord {
  static get field_label() {
    return "色テーマ"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "light_mode",      name: "ライト",   type: "is-primary", message: null, },
      { key: "dark_mode",       name: "ダーク",   type: "is-primary", message: null, },
      { key: "matrix_mode",     name: "グリーン", type: "is-primary", message: null, },
      { key: "orange_lcd_mode", name: "オレンジ", type: "is-primary", message: null, },
    ]
  }
}
