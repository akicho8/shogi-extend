import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class LogicalopInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "and", name: "すべて", },
      { key: "or",  name: "どれか", },
    ]
  }

  css_class(current_key) {
    if (this.key === current_key) {
      return "has-text-weight-bold"
    }
  }

  get yomiage() {
    return `${this.name}を含む`
  }
}
