import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class LogicalInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "and", name: "すべて",   search_key: "tag",         yomiage: "すべて含む",     },
      { key: "or",  name: "どれか",   search_key: "any-tag",     yomiage: "どれか含む",     },
      { key: "not", name: "含まない", search_key: "exclude-tag", yomiage: "どれも含まない", },
    ]
  }

  css_class(current_key) {
    if (this.key === current_key) {
      return "has-text-weight-bold"
    }
  }

  search_key_for(versus_p) {
    let vs = ""
    if (versus_p) {
      vs = "vs-"
    }
    return `${vs}${this.search_key}`
  }
}
