import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SoldierHflipInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "flip_off", name: "反転しない", },
      { key: "flip_on",  name: "反転する",   },
    ]
  }
}
