import MemoryRecord from 'js-memory-record'

export class ShoutInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "is_shout_on",  name: "あり", message: null, },
      { key: "is_shout_off", name: "なし", message: null, },
    ]
  }
}
