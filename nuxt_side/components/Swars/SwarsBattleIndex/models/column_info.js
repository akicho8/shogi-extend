import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ColumnInfo extends ApplicationMemoryRecord {
  // static field_label = "デバッグ"
  // static field_message = ""

  static get define() {
    return [
      { key: "id",               name: "ID",   visible: true,  },
      { key: "attack_tag_list",  name: "戦型", visible: true,  },
      { key: "defense_tag_list", name: "囲い", visible: true,  },
      { key: "final_info",       name: "結果", visible: false, },
      { key: "turn_max",         name: "手数", visible: false, },
      { key: "critical_turn",    name: "開戦", visible: false, },
      { key: "outbreak_turn",    name: "中盤", visible: false, },
      { key: "grade_diff",       name: "力差", visible: false, },
      { key: "rule_info",        name: "種類", visible: false, },
      { key: "preset_info",      name: "手合", visible: false, },
      { key: "battled_at",       name: "日時", visible: true,  },
    ]
  }
}
