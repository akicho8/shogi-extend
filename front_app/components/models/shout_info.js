import MemoryRecord from 'js-memory-record'

export class ShoutInfo extends MemoryRecord {
  static get message() { return "駒が叫ぶ" }

  static get define() {
    return [
      { key: "is_shout_off", name: "なし", message: null, },
      { key: "is_shout_on",  name: "あり", message: null, },
    ]
  }
}
