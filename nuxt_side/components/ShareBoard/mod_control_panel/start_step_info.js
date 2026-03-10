import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class StartStepInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "gate_modal_open_handle",
        name: "入退室",
        // mobile_name: "入室",
        icon: "🛖",
        todo_p: "step1_todo_p",
        done_p: "step1_done_p",
      },
      {
        key: "order_modal_open_handle",
        name: "順番設定",
        // mobile_name: "順番設定",
        icon: "👫", // ⚔️ 👫 🆚
        todo_p: "step2_todo_p",
        done_p: "step2_done_p",
      },
      {
        key: "cc_modal_open_handle",
        name: "対局時計",
        // mobile_name: "対局時計",
        icon: "⏱",
        todo_p: "step3_todo_p",
        done_p: "step3_done_p",
      },
    ]
  }
}
