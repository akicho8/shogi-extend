import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ViewpointInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "black", name: "常に☗ (詰将棋向け)",                                       },
      { key: "white", name: "常に☖ (逃れ将棋向け)",                                     },
    ]
  }
}
