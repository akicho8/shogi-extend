import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SoldierFlopInfo extends ApplicationMemoryRecord {
  static field_label = "盤上の駒を左右反転"

  // FIXME: flop が正しい
  static get define() {
    return [
      { key: "flip_off", name: "しない", },
      { key: "flip_on",  name: "する",   },
    ]
  }
}
