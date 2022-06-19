import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MoveGuardInfo extends ApplicationMemoryRecord {
  static field_label = "手番制限"
  static field_message = ""
  static hint_messages = ["制限すると手番の人だけが駒を動かせるようになります"]

  static get define() {
    return [
      { key: "is_move_guard_on",  name: "あり", type: "is-primary", message: "手番の人だけが駒を動かせる",         },
      { key: "is_move_guard_off", name: "なし", type: "is-primary", message: "動かそうと思えば誰でも駒を動かせる", },
    ]
  }
}
