import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class CtrlModeInfo extends ApplicationMemoryRecord {
  static field_label = "対局時のコントローラー表示"
  static field_message = "時計が動いているときを対局中と想定している。誤タップが気になる場合は隠そう"

  static get define() {
    return [
      { key: "is_ctrl_mode_hidden",  name: "隠す", type: "is-primary", message: null, },
      { key: "is_ctrl_mode_visible", name: "表示", type: "is-primary", message: null, },
    ]
  }
}
