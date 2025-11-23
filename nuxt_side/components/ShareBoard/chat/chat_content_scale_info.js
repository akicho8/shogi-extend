import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChatContentScaleInfo extends ApplicationMemoryRecord {
  static field_label = "チャット画面のサイズ"
  static field_message = ""

  static get define() {
    return [
      { key: "ccs_small", name: "小さめ", type: "is-primary", message: "デフォルト",         full_screen_p: false, },
      { key: "ccs_large", name: "大きめ", type: "is-warning", message: "大きめというか最大", full_screen_p: true,  },
    ]
  }
}
