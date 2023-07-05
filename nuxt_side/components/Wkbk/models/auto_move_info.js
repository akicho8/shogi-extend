import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AutoMoveInfo extends ApplicationMemoryRecord {
  static field_label = "自動応手"

  static get define() {
    return [
      { key: "auto_move_on",  name: "する",   },
      { key: "auto_move_off", name: "しない", },
    ]
  }
}
