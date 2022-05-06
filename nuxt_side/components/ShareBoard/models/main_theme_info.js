import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MainThemeInfo extends ApplicationMemoryRecord {
  static field_label = "テーマ"
  static field_message = ""

  static get define() {
    return [
      { key: "is_main_theme_a", name: "A", },
      { key: "is_main_theme_b", name: "B", },
    ]
  }
}
