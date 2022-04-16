import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class RuleSelectInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "",     name: "すべての持ち時間", },
      { key: "10分", name: "10分",             },
      { key: "3分",  name: "3分",              },
      { key: "10秒", name: "10秒",             },
    ]
  }
}
