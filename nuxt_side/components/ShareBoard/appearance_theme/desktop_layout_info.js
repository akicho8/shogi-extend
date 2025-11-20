import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class DesktopLayoutInfo extends ApplicationMemoryRecord {
  static field_label = "PC用画面レイアウト"
  static field_message = ""

  static get define() {
    return [
      { key: "dl_horizontal", name: "横長", sp_layout: "horizontal", type: "is-primary", message: "左右に持駒を配置する (推奨盤サイズ<b>90%</b>)", },
      { key: "dl_vertical",   name: "縦長", sp_layout: "vertical",   type: "is-warning", message: "上下に持駒を配置する (推奨盤サイズ<b>60%</b>)", },
    ]
  }
}
