import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class RuleSelectInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { name: "10分", },
      { name: "3分",  },
      { name: "10秒", },
    ]
  }
}
