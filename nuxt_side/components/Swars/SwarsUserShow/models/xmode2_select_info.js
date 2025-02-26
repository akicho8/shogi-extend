import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class Xmode2SelectInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "",           name: "すべて",     },
      { key: "通常",       name: "通常",       },
      { key: "スプリント", name: "スプリント", },
    ]
  }
}
