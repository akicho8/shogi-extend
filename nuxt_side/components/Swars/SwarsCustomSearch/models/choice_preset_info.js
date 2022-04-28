import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChoicePresetInfo extends ApplicationMemoryRecord {
  static field_label = "手合"
  static field_message = null

  static get define() {
    return [
      { key: "すべて",    name: "すべて",   type: "is-primary", message: null, },
      { key: "平手",      name: "平手",     type: "is-primary", message: null, },
      { key: "角落ち",    name: "角落ち",   type: "is-primary", message: null, },
      { key: "飛車落ち",  name: "飛車落ち", type: "is-primary", message: null, },
      { key: "二枚落ち",  name: "二枚落ち", type: "is-primary", message: null, },
      { key: "四枚落ち",  name: "四枚落ち", type: "is-primary", message: null, },
      { key: "六枚落ち",  name: "六枚落ち", type: "is-primary", message: null, },
      { key: "八枚落ち",  name: "八枚落ち", type: "is-primary", message: null, },
    ]
  }

  get to_query_part() {
    if (this.key != "すべて") {
      return `手合:${this.key}`
    }
  }
}
