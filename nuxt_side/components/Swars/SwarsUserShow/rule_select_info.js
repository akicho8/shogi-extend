import MemoryRecord from 'js-memory-record'

export class RuleSelectInfo extends MemoryRecord {
  static get define() {
    return [
      { name: "10分", },
      { name: "3分",  },
      { name: "10秒", },
    ]
  }
}
