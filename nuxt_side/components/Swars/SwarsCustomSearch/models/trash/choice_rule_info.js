import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChoiceRuleInfo extends ApplicationMemoryRecord {
  static field_label = "持ち時間"
  static field_message = null

  static get define() {
    return [
      { key: "すべて", type: "is-primary", message: null, },
      { key: "10分",   type: "is-primary", message: null, },
      { key: "3分",    type: "is-primary", message: null, },
      { key: "10秒",   type: "is-primary", message: null, },
    ]
  }

  get to_query_part() {
    if (this.key != "すべて") {
      return `持ち時間:${this.key}`
    }
  }
}
