import MemoryRecord from 'js-memory-record'

export class ShoutInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "shout_on",  name: "あり", message: null, },
      { key: "shout_off", name: "なし", message: null, },
    ]
  }
}
