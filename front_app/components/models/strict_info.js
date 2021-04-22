import MemoryRecord from 'js-memory-record'

export class StrictInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "turn_strict_on",  name: "あり", message: "手番の人だけが駒を動かせる",                             },
      { key: "turn_strict_off", name: "なし", message: "動かそうと思えばいつでも誰でも駒を動かせる(以前の仕様)", },
    ]
  }
}
