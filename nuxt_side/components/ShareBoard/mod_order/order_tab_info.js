import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class OrderTabInfo extends ApplicationMemoryRecord {
  static get define() { return require("./order_tab_info.definition.js") }
}
