import MemoryRecord from 'js-memory-record'

export class PieceFontWeightInfo extends MemoryRecord {
  static field_label = "駒書体の太さ"
  static field_message = ""

  static get define() {
    return [
      { key: "is_piece_font_weight_normal", name: "最後の指し手", type: "is-primary", message: "あっさり", to_params: {                                                       }, },
      { key: "is_piece_font_weight_bold", name: "常に太字",     type: "is-primary", message: "こってり", to_params: { soldier_font_bold: true, stand_piece_font_bold: true, }, },
    ]
  }
}
