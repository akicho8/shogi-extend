import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MainThemeInfo extends ApplicationMemoryRecord {
  static field_label = "テーマ"
  static field_message = ""

  // main_theme.sass
  static get define() {
    return [
      { key: "is_main_theme_a", name: "A", navbar_type: "is-primary", },
      { key: "is_main_theme_b", name: "B", navbar_type: "is-black",   },
    ]
  }

  get to_style() {
    return {
    }
  }
}
