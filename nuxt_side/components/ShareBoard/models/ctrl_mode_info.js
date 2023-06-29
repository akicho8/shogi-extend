import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class CtrlModeInfo extends ApplicationMemoryRecord {
  static field_label = "対局時の盤面下コントローラー"
  static field_message = "時計が動いているときを対局中と想定している。誤タップ防止のために隠しておこう"

  static get define() {
    return [
      { key: "is_ctrl_mode_hidden",  name: "隠す", type: "is-primary", message: null, },
      { key: "is_ctrl_mode_visible", name: "表示", type: "is-warning", message: null, },
    ]
  }
}
