import MemoryRecord from 'js-memory-record'

export class AvatarKingInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "avatar_king_on",  name: "あり", message: null, },
      { key: "avatar_king_off", name: "なし", message: null, },
    ]
  }
}
