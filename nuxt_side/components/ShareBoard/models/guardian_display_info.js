import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class GuardianDisplayInfo extends ApplicationMemoryRecord {
  static get message() { return null }

  static get define() {
    return [
      { key: "is_guardian_display_on",  name: "あり", message: "アイコン表示する",   },
      { key: "is_guardian_display_off", name: "なし", message: "アイコン表示しない", },
    ]
  }
}
