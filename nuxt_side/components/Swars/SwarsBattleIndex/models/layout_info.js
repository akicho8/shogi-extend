import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class LayoutInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "is_layout_table", name: "一覧", },
      { key: "is_layout_board", name: "盤面", },
    ]
  }
}
