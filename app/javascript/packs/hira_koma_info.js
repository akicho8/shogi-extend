import MemoryRecord from 'js-memory-record'

export default class HiraKomaInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "hira", name: "平手",   },
      { key: "koma", name: "駒落ち", },
    ]
  }
}
