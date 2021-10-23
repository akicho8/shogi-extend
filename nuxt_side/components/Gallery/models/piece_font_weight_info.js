import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class PieceFontWeightInfo extends ApplicationMemoryRecord {
  static field_label = "駒書体の太さ"
  static field_message = ""

  static get define() {
    return [
      { key: "is_piece_font_weight_normal", name: "最後の指し手", type: "is-primary", message: "あっさり", to_params: {                                                       }, },
      { key: "is_piece_font_weight_bold", name: "常に太字",     type: "is-primary", message: "こってり", to_params: { soldier_font_bold: true, stand_piece_font_bold: true, }, },
    ]
  }
}
