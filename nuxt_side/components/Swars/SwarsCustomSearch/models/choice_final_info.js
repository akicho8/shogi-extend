import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChoiceFinalInfo extends ApplicationMemoryRecord {
  static field_label = "結果"
  static field_message = null

  static get define() {
    return [
      { key: "すべて",           type: "is-primary", message: null, },
      { key: "投了",             type: "is-primary", message: null, },
      { key: "時間切れ",         type: "is-primary", message: null, },
      { key: "詰み",             type: "is-primary", message: null, },
      { key: "切断",             type: "is-primary", message: null, },
      { key: "入玉",             type: "is-primary", message: null, },
      { key: "千日手",           type: "is-primary", message: null, },
      { key: "連続王手の千日手", type: "is-primary", message: null, },
    ]
  }

  get to_query_part() {
    if (this.key != "すべて") {
      return `結果:${this.key}`
    }
  }
}
