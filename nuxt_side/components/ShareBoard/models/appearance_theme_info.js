import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AppearanceThemeInfo extends ApplicationMemoryRecord {
  static field_label = "テーマ"
  static field_message = ""

  // appearance_theme.sass
  static get define() {
    return [
      { key: "is_appearance_theme_a", name: "A", navbar_type: "is-primary", sp_bg_variant: "is_bg_variant_none", sp_pi_variant: "is_pi_variant_a" },
      { key: "is_appearance_theme_b", name: "B", navbar_type: "is-black",   sp_bg_variant: "is_bg_variant_none", sp_pi_variant: "is_pi_variant_a" },
      { key: "is_appearance_theme_c", name: "C", navbar_type: "is-black",   sp_bg_variant: "is_bg_variant_a",    sp_pi_variant: "is_pi_variant_d" },
    ]
  }

  get to_style() {
    return {
    }
  }
}
