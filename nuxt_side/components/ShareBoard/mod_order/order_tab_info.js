import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class OrderTabInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "order_tab_main", name: "順番",   },
      { key: "order_tab_fes",  name: "投票",   },
      { key: "order_tab_rule", name: "ルール", },
    ]
  }
}
