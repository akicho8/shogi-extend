import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MobileLayoutInfo extends ApplicationMemoryRecord {
  static field_label = "スマホ用画面レイアウト"
  static field_message = "持駒が見切れる人は<b>横長</b>にしよう"

  static get define() {
    return [
      { key: "ml_vertical",   name: "縦長", sp_mobile_vertical: true,  type: "is-primary", message: null, },
      { key: "ml_horizontal", name: "横長", sp_mobile_vertical: false, type: "is-warning", message: null, },
    ]
  }
}
