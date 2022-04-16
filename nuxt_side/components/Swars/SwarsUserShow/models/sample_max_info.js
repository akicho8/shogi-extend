import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SampleMaxInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { name: "最大50件",  value: 50,  },
      { name: "最大100件", value: 100, },
      { name: "最大200件", value: 200, },
    ]
  }
}
