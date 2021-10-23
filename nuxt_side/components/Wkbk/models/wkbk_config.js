import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class WkbkConfig extends MemoryRecord {
  static get define() {
    return [
      { key: "per_page",                       value: 50,                                    description: "", },
      { key: "top_tag_display_p",              value: process.env.NODE_ENV !== "production", description: "", },
      { key: "moves_answers_empty_validate_p", value: true,                                  description: "正解が未登録は許さない", },
      { key: "valid_requied",                  value: false,                                 description: "必ず検証してもらう",     },
    ]
  }
  static value_of(key) {
    return this.fetch(key).value
  }
}
