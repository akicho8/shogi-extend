import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AppearanceThemeInfo extends ApplicationMemoryRecord {
  static field_label = "スタイル"
  static field_message = ""

  static get define() {
    return [
      { key: "is_appearance_theme_a", name: "ライト", navbar_type: "is-primary", sp_board_variant: "none",   sp_piece_variant: "nureyon",  },
      { key: "is_appearance_theme_b", name: "ダーク", navbar_type: "is-black",   sp_board_variant: "none",   sp_piece_variant: "nureyon",  },
      { key: "is_appearance_theme_c", name: "リアル", navbar_type: "is-black",   sp_board_variant: "wood_normal", sp_piece_variant: "portella", },
    ]
  }

  get to_css_vars() {
    return {
    }
  }
}
