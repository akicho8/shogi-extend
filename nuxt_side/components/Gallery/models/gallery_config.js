import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class GalleryConfig extends ApplicationMemoryRecord {
  static get define() {
    return [
    ]
  }
  static value_of(key) {
    return this.fetch(key).value
  }
}
