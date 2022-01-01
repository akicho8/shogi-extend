import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ShowBehaviourInfo extends ApplicationMemoryRecord {
  static field_label = "出題方法"

  static get define() {
    return [
      { key: "show_behaviour_board", name: "表示",     },
      { key: "show_behaviour_blind", name: "読み上げ", },
    ]
  }
}
