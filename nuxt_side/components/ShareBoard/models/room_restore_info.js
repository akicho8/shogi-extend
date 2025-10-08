import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class RoomRestoreInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "enable", name: "復元する",   },
      { key: "skip",   name: "復元しない", },
    ]
  }
}
