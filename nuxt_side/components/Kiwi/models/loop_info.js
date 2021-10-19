import MemoryRecord from 'js-memory-record'

export class LoopInfo extends MemoryRecord {
  static field_label = "ループ"
  static field_message = "GIFにのみ有効だけどTwitterでは1分以下ならループする"

  static get define() {
    return [
      { key: "is_loop_infinite", name: "する",   type: "is-primary", message: null, },
      { key: "is_loop_none",     name: "しない", type: "is-primary", message: null, },
    ]
  }
}
