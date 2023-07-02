import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SoldierFlopInfo extends ApplicationMemoryRecord {
  static field_label = "盤上の駒を左右反転"

  static get define() {
    return [
      { key: "flop_off", name: "しない", },
      { key: "flop_on",  name: "する",   },
    ]
  }
}
