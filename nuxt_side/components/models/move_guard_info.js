import MemoryRecord from 'js-memory-record'

export class MoveGuardInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "is_move_guard_on",  name: "あり", message: "手番の人だけが駒を動かせる",         },
      { key: "is_move_guard_off", name: "なし", message: "動かそうと思えば誰でも駒を動かせる", },
    ]
  }
}
