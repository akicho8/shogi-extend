import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class StyleInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "王道",   },
      { key: "準王道", },
      { key: "準変態", },
      { key: "変態",   },
    ]
  }
}
