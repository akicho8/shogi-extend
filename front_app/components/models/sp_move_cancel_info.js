import MemoryRecord from 'js-memory-record'

export class SpMoveCancelInfo extends MemoryRecord {
  static get field_label() {
    return "持ち上げた駒のキャンセル方法"
  }

  static get field_message() {
    return "右クリックやESCキーでもキャンセル可。この設定はブラウザに保存する"
  }

  static get define() {
    return [
      { key: "is_move_cancel_hard", name: "移動元をタップ",   type: "is-primary", message: null, },
      { key: "is_move_cancel_easy", name: "他のセルをタップ", type: "is-primary", message: null, },
    ]
  }
}
