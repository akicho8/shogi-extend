import { MemoryRecord } from 'js-memory-record'

class LastActionInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "TORYO",        name: "投了",     },
      { key: "TIME_UP",      name: "時間切れ", },
      { key: "ILLEGAL_MOVE", name: "反則",     },
      { key: "TSUMI",        name: "詰み",     },
    ]
  }
}

export { LastActionInfo }
