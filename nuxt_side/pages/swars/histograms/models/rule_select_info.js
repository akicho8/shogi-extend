import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class RuleSelectInfo extends ApplicationMemoryRecord {
  static field_label = "ルール"

  static get define() {
    return [
      { key: "ten_min",   name: "10分", },
      { key: "three_min", name: "3分",  },
      { key: "ten_sec",   name: "10秒", },
      { key: "all",       name: "(all)", },
    ]
  }
}
