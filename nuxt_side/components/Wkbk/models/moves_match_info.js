import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MovesMatchInfo extends ApplicationMemoryRecord {
  static field_label = "正解と比較する範囲"

  static get define() {
    return [
      { key: "all",   name: "全体", },
      { key: "first", name: "初手", },
    ]
  }
}
