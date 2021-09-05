import MemoryRecord from 'js-memory-record'

export class TimeLimitInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "default", name: "自首", },
      { key: "judge",   name: "判定", },
    ]
  }
}
