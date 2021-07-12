import MemoryRecord from 'js-memory-record'

export class ShoutModeInfo extends MemoryRecord {
  static get message() { return null }

  static get define() {
    return [
      { key: "is_shout_mode_off", name: "なし", message: "叫ばない",         },
      { key: "is_shout_mode_on",  name: "あり", message: "いちいち駒が叫ぶ", },
    ]
  }
}
