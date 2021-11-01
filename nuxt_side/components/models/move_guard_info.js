import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MoveGuardInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "is_move_guard_on",  name: "あり", message: "手番の人だけが駒を動かせる",         },
      { key: "is_move_guard_off", name: "なし", message: "動かそうと思えば誰でも駒を動かせる", },
    ]
  }
}
