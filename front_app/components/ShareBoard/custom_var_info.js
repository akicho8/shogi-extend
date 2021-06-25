import MemoryRecord from 'js-memory-record'

export class CustomVarInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "avatar_king_key", type: "string", name: "アバター表示", default: { development: "is_avatar_king_on", production: "is_avatar_king_on", }, },
    ]
  }
}
