import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class StartStepInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "gate_modal_open_handle",
        name: "入室",
        icon: "mdi-numeric-1-circle-outline",
        todo_p: "step1_todo_p",
        done_p: "step1_done_p",
      },
      {
        key: "order_modal_open_handle",
        name: "対局設定",
        icon: "mdi-numeric-2-circle-outline",
        todo_p: "step2_todo_p",
        done_p: "step2_done_p",
      },
      {
        key: "cc_modal_open_handle",
        name: "時計",
        icon: "mdi-numeric-3-circle-outline",
        todo_p: "step3_todo_p",
        done_p: "step3_done_p",
      },
    ]
  }
}
