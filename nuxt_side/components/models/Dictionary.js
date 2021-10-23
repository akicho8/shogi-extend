import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class Dictionary extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "id",               name: "ID",   },
      { key: "attack_tag_list",  name: "戦型", },
      { key: "defense_tag_list", name: "囲い", },
      { key: "final_info",       name: "結果", },
      { key: "turn_max",         name: "手数", },
      { key: "critical_turn",    name: "開戦", },
      { key: "outbreak_turn",    name: "中盤", },
      { key: "grade_diff",       name: "力差", },
      { key: "rule_info",        name: "種類", },
      { key: "preset_info",      name: "手合", },
      { key: "battled_at",       name: "日時", },
      { key: "asc",              name: "昇順", },
      { key: "desc",             name: "降順", },
    ]
  }
}
