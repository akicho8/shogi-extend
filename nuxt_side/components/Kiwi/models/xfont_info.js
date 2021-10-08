import MemoryRecord from 'js-memory-record'

export class XfontInfo extends MemoryRecord {
  static get field_label() {
    return "駒を太字にする条件"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "is_font_bold", name: "常に太字",     type: "is-primary", message: null, to_params: { soldier_font_bold: true,  stand_piece_font_bold: true, }, },
      { key: "is_font_auto", name: "最後の指し手", type: "is-primary", message: null, to_params: {                                                        }, },
    ]
  }
}
