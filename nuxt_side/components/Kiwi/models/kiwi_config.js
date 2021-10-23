import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class KiwiConfig extends MemoryRecord {
  static get define() {
    return [
      { key: "per_page",                       value: 50,    description: "", },
      { key: "moves_answers_empty_validate_p", value: true,  description: "正解が未登録は許さない", },
      { key: "valid_requied",                  value: false, description: "必ず検証してもらう",     },
    ]
  }
  static value_of(key) {
    return this.fetch(key).value
  }
}
