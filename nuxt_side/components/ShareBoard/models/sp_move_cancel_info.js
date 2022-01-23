import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SpMoveCancelInfo extends ApplicationMemoryRecord {
  static field_label = "どこをタップしたら持った駒を離す？*"
  static field_message = "右クリックやESCキーでもキャンセル可"

  static get define() {
    return [
      { key: "is_move_cancel_standard", name: "移動先以外", type: "is-primary", message: null, },
      { key: "is_move_cancel_reality",  name: "移動元",     type: "is-primary", message: null, },
    ]
  }
}
