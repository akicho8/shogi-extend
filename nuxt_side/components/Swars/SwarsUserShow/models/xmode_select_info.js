import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class XmodeSelectInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "",     name: "すべてのモード", },
      { key: "通常", name: "通常",           },
      { key: "友達", name: "友達",           },
      { key: "指導", name: "指導",           },
    ]
  }
}
