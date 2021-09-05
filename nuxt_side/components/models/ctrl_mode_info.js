import MemoryRecord from 'js-memory-record'

export class CtrlModeInfo extends MemoryRecord {
  static get field_label() {
    return "対局時のコントローラー表示"
  }

  static get field_message() {
    return "時計が動いているときを対局中と想定している。誤タップが気になる場合は隠そう"
  }

  static get define() {
    return [
      { key: "is_ctrl_mode_hidden",  name: "隠す", type: "is-primary", message: null, },
      { key: "is_ctrl_mode_visible", name: "表示", type: "is-primary", message: null, },
    ]
  }
}
