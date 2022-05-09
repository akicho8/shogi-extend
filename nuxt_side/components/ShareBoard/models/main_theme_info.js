import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MainThemeInfo extends ApplicationMemoryRecord {
  static field_label = "テーマ"
  static field_message = ""

  static get define() {
    return [
      { key: "is_main_theme_a", name: "A", navbar_default_color_type: "is-primary", },
      { key: "is_main_theme_b", name: "B", navbar_default_color_type: "is-sbc1",   },
      { key: "is_main_theme_c", name: "C", navbar_default_color_type: "is-dark",   },
    ]
  }

  get to_style() {
    return {
    }
  }
}
