import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MobileLayoutInfo extends ApplicationMemoryRecord {
  static field_label = "画面レイアウト (スマホ利用時)"
  static field_message = ""

  static get define() {
    return [
      { key: "ml_vertical",   name: "基本", sp_mobile_vertical: true,  type: "is-primary", message: "盤の横幅を最大化する (推奨)", },
      { key: "ml_horizontal", name: "縮小", sp_mobile_vertical: false, type: "is-warning", message: "持駒が見切れる端末用",        },
    ]
  }
}
