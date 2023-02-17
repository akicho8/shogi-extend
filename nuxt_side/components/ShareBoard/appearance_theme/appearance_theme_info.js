import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AppearanceThemeInfo extends ApplicationMemoryRecord {
  static field_label = "モード"
  static field_message = ""

  static get define() {
    return [
      { key: "is_appearance_theme_a", name: "ライト", navbar_type: "is-primary", sp_bg_variant: "none", sp_piece_variant: "a" },
      { key: "is_appearance_theme_b", name: "ダーク", navbar_type: "is-black",   sp_bg_variant: "none", sp_piece_variant: "a" },
      { key: "is_appearance_theme_c", name: "リアル", navbar_type: "is-black",   sp_bg_variant: "a",    sp_piece_variant: "d" },
    ]
  }

  get to_style() {
    return {
    }
  }
}
