import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MobileLayoutInfo extends ApplicationMemoryRecord {
  static field_label = "持駒位置 (スマホ利用時)"
  static field_message = ""

  static get define() {
    return [
      { key: "ml_vertical",   name: "上下", sp_mobile_vertical: true,  message: "盤の横幅を最大化する (推奨)", },
      { key: "ml_horizontal", name: "左右", sp_mobile_vertical: false, message: "縦幅が小さすぎるスマホ向け",  },
    ]
  }
}
