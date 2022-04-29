import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChoiceJudgeInfo extends ApplicationMemoryRecord {
  static field_label = "勝敗"
  static field_message = null

  static get define() {
    return [
      { key: "none",     name: "すべて",   type: "is-primary", message: null, },
      { key: "勝ち",     name: "勝ち",     type: "is-primary", message: null, },
      { key: "負け",     name: "負け",     type: "is-primary", message: null, },
      { key: "引き分け", name: "引き分け", type: "is-primary", message: null, },
    ]
  }

  get to_query_part() {
    if (this.key != "none") {
      return `勝敗:${this.key}`
    }
  }
}
