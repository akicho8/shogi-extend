import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class CorrectBehaviorInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "go_to_next", name: "次に進む",     },
      { key: "stay",       name: "次に進まない", },
    ]
  }
}
