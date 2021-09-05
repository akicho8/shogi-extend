import MemoryRecord from 'js-memory-record'

export class SoldierHflipInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "flip_off", name: "反転しない", },
      { key: "flip_on",  name: "反転する",   },
    ]
  }
}
