import MemoryRecord from 'js-memory-record'

export class StrictInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "turn_strict_on",  name: "あり", message: "自分の手番のときだけ駒を動かせる",                               },
      { key: "turn_strict_off", name: "なし", message: "手番に関係なく動かそうと思えばいつでも駒を動かせる(以前の仕様)", },
    ]
  }
}
