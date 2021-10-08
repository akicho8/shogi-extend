import MemoryRecord from 'js-memory-record'

export class XboldInfo extends MemoryRecord {
  static get field_label() {
    return "駒を太字にする条件"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "is_xbold_always", name: "常に太字",     type: "is-primary", message: null, to_params: { soldier_font_bold: true, stand_piece_font_bold: true, }, },
      { key: "is_xbold_latest", name: "最後の指し手", type: "is-primary", message: null, to_params: {                                                       }, },
    ]
  }
}
