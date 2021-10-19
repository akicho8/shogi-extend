import MemoryRecord from 'js-memory-record'

export class PieceFontWeightInfo extends MemoryRecord {
  static field_label = "駒書体の太さ"
  static field_message = ""

  static get define() {
    return [
      { key: "is_piece_font_weight_auto", name: "おまかせ", type: "is-primary", message: "だいだい細字",                  },
      { key: "is_piece_font_weight_normal",  name: "細字",     type: "is-primary", message: "あっさり (最後の指し手は太字)", },
      { key: "is_piece_font_weight_bold",   name: "太字",     type: "is-primary", message: "こってり",                      },
    ]
  }
}
