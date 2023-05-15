import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AutoResignInfo extends ApplicationMemoryRecord {
  static field_label = "自動投了"
  static message = null
  static hint_messages = ["時間切れや反則時に即負けとするか？"]

  static get define() {
    return [
      { key: "is_auto_resign_on",  name: "する",   message: "時間切れや反則は即負け (推奨)",     environment: ["development", "staging", "production"], },
      { key: "is_auto_resign_off", name: "しない", message: "投了は本人が任意で行う (接待向け)", environment: ["development", "staging", "production"], },
    ]
  }
}
