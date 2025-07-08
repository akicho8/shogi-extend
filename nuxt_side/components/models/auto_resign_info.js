import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AutoResignInfo extends ApplicationMemoryRecord {
  static field_label = "時間切れになったときの自動投了"
  static message = null
  static hint_messages = ["時間切れや反則時に即負けとするか？"]

  static get define() {
    return [
      { key: "is_auto_resign_on",  name: "する",   type: "is-primary", message: "時間切れや反則は潔く負けとする (推奨)",               environment: ["development", "staging", "production"], },
      { key: "is_auto_resign_off", name: "しない", type: "is-danger",  message: "時間切れや反則でも投了しなければ続行できる (接待用)", environment: ["development", "staging", "production"], },
    ]
  }
}
