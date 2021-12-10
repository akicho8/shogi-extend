import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class DisplayInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "list",     name: "一覧", board_show_p: false, type: "is-primary", message: null, },
      { key: "critical", name: "開戦", board_show_p: true,  type: "is-primary", message: null, },
      { key: "outbreak", name: "中盤", board_show_p: true,  type: "is-primary", message: null, },
      { key: "last",     name: "終局", board_show_p: true,  type: "is-primary", message: null, },
    ]
  }

  get div_class() {
    return `is_display_${this.key}`
  }
}
