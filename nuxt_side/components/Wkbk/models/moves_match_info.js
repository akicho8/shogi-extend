import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MovesMatchInfo extends ApplicationMemoryRecord {
  static field_label = "○○が一致したら正解とする"

  static get define() {
    return [
      { key: "all",   name: "全体", },
      { key: "first", name: "初手", },
    ]
  }
}
