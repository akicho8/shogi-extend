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
      { key: "light_mode",      name: "白", type: "is-primary", message: null, },
      { key: "dark_mode",       name: "灰", type: "is-primary", message: null, },
      { key: "matrix_mode",     name: "緑", type: "is-primary", message: null, },
      { key: "orange_lcd_mode", name: "橙", type: "is-primary", message: null, },
    ]
  }
}
