import MemoryRecord from 'js-memory-record'

export class CorrectBehaviorInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "go_to_next", name: "次に進む",     },
      { key: "stay",       name: "次に進まない", },
    ]
  }
}
