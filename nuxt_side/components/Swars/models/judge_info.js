import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class JudgeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "win",  name: "勝ち",     },
      { key: "lose", name: "負け",     },
      { key: "draw", name: "引き分け", },
    ]
  }
}
