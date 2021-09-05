import MemoryRecord from 'js-memory-record'

export class XfontInfo extends MemoryRecord {
  static get field_label() {
    return "駒の文字の太さ"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "is_font_auto",    name: "自動", type: "is-primary", message: null, to_params: {                                                         }, },
      { key: "is_font_regular", name: "通常", type: "is-primary", message: null, to_params: { soldier_font_bold: false, stand_piece_font_bold: false, }, },
      { key: "is_font_bold",    name: "太字", type: "is-primary", message: null, to_params: { soldier_font_bold: true,  stand_piece_font_bold: true,  }, },
    ]
  }
}
