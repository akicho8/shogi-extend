import MemoryRecord from 'js-memory-record'

export class ShoutModeInfo extends MemoryRecord {
  static get message() { return "駒が叫ぶ" }

  static get define() {
    return [
      { key: "is_shout_mode_off", name: "なし", message: null, },
      { key: "is_shout_mode_on",  name: "あり", message: null, },
    ]
  }
}
