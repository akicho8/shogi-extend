import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class DesktopLayoutInfo extends ApplicationMemoryRecord {
  static field_label = "レイアウト (PC)"
  static field_message = ""

  static get define() {
    return [
      { key: "dl_horizontal", name: "横長", sp_layout: "horizontal", type: "is-primary", message: "持駒を左右に配置する (推奨盤サイズ<b>90%</b>)", },
      { key: "dl_vertical",   name: "縦長", sp_layout: "vertical",   type: "is-warning", message: "持駒を上下に配置する (推奨盤サイズ<b>60%</b>)", },
    ]
  }
}
