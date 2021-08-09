import MemoryRecord from 'js-memory-record'

export class LoopInfo extends MemoryRecord {
  static get field_label() {
    return "ループ"
  }

  static get field_message() {
    return "GIFにのみ有効だがTwitterではそれに構わず1分以下の動画はループする"
  }

  static get define() {
    return [
      { key: "is_loop_infinite", name: "する",   type: "is-primary", message: null, },
      { key: "is_loop_once",     name: "しない", type: "is-primary", message: null, },
    ]
  }
}
