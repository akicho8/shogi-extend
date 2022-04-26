import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChoiceLoopInfo extends ApplicationMemoryRecord {
  static field_label = "対局モード"
  static field_message = null

  static get define() {
    return [
      { key: "none", name: "すべて", type: "is-primary", message: null, },
      { key: "通常", name: "通常",   type: "is-primary", message: null, },
      { key: "友達", name: "友達",   type: "is-primary", message: null, },
      { key: "指導", name: "指導",   type: "is-primary", message: null, },
    ]
  }

  get to_query_part() {
    if (this.key != "none") {
      return `対局モード:${this.key}`
    }
  }
}
