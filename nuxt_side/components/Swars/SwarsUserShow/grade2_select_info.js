import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class Grade2SelectInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { name: "通常", },
      { name: "友達", },
      { name: "指導", },
    ]
  }
}
