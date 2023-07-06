import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class CorrectBehaviorInfo extends ApplicationMemoryRecord {
  static field_label = "駒操作で正解したら次に進むか？"

  static get define() {
    return [
      { key: "correct_behavior_next", name: "進む",     },
      { key: "correct_behavior_stay",       name: "進まない", },
    ]
  }
}
