import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AutoResignInfo extends ApplicationMemoryRecord {
  static field_label = "時間切れになったら自動的に投了"
  static message = null
  static hint_messages = ["反則も含む"]

  static get define() {
    return [
      { key: "is_auto_resign_off", name: "しない", message: "投了は任意で選択する", resign_auto_run: false, environment: ["development", "staging", "production"], },
      { key: "is_auto_resign_on",  name: "する",   message: "自動的に投了する",     resign_auto_run: true,  environment: ["development", "staging", "production"], },
    ]
  }
}
