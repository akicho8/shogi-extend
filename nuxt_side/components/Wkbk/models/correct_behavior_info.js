import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class CorrectBehaviorInfo extends ApplicationMemoryRecord {
  static field_label = "駒操作で正解したら次に"

  static get define() {
    return [
      { key: "go_to_next", name: "進む",     },
      { key: "stay",       name: "進まない", },
    ]
  }
}
