import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChartScopeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "chart_scope_recently", name: "最近", },
      { key: "chart_scope_all",      name: "全体", },
    ]
  }
}
