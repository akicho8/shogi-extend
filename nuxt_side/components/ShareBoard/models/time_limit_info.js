import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TimeLimitInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "default", name: "自首", },
      { key: "judge",   name: "判定", },
    ]
  }
}
