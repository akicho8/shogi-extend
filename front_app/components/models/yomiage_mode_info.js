import MemoryRecord from 'js-memory-record'

export class YomiageModeInfo extends MemoryRecord {
  static get field_label() {
    return "検討時の棋譜読み上げ"
  }

  static get field_message() {
    return "時計を設置していないときを検討時と想定している。検討に集中したいときは「しない」にしよう"
  }

  static get define() {
    return [
      { key: "is_yomiage_mode_on",  name: "する",   type: "is-primary", message: null, },
      { key: "is_yomiage_mode_off", name: "しない", type: "is-primary", message: null, },
    ]
  }
}
