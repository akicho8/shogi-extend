import MemoryRecord from 'js-memory-record'

export class LoopInfo extends MemoryRecord {
  static get field_label() {
    return "ループ (GIFでのみ有効)"
  }

  static get field_message() {
    return "この設定に関係なくTwitterでは60秒以下の動画はループする"
  }

  static get define() {
    return [
      { key: "is_loop_infinite", name: "する",   type: "is-primary", message: null, },
      { key: "is_loop_once",     name: "しない", type: "is-primary", message: null, },
    ]
  }
}
