import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class JudgeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "win",  name: "勝ち",     },
      { key: "lose", name: "負け",     },
      { key: "draw", name: "引き分け", },
    ]
  }

  static lookup(key) {
    return super.lookup(key) || this.invert_table[key]
  }

  static get invert_table() {
    if (this._invert_table != null) {
      return this._invert_table
    }
    this._invert_table = this.memory_record_create_index_by(["name"])
    return this._invert_table
  }
}
