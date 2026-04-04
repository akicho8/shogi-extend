import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChatButtonVisibilityInfo extends ApplicationMemoryRecord {
  static field_label = "チャット画面を開くボタンを表示"
  static field_message = ""

  static get define() {
    return [
      { key: "cbv_visible", name: "する",   type: "is-primary", show_p: true,  message: "スマホまたは初心者向け",                                    },
      { key: "cbv_hidden",  name: "しない", type: "is-primary", show_p: false, message: "PC利用者かつ玄人向け (Enter で開けるためボタンは要らない)", },
    ]
  }
}
