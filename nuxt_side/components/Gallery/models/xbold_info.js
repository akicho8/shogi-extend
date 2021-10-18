import MemoryRecord from 'js-memory-record'

export class XboldInfo extends MemoryRecord {
  static get field_label() {
    return "駒書体の太さ"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "is_xbold_off", name: "最後の指し手", type: "is-primary", message: "あっさり", to_params: {                                                       }, },
      { key: "is_xbold_on", name: "常に太字",     type: "is-primary", message: "こってり", to_params: { soldier_font_bold: true, stand_piece_font_bold: true, }, },
    ]
  }
}
