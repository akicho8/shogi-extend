import MemoryRecord from 'js-memory-record'

export class ParamInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "foo1_key", type: "string", name: "クリック反応", default: "pointerdown", permanent: true, relation: "Foo1Info", desc: "", },
    ]
  }
}
