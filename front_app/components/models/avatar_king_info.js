import MemoryRecord from 'js-memory-record'

export class AvatarKingInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "is_avatar_king_on",  name: "あり", message: null, },
      { key: "is_avatar_king_off", name: "なし", message: null, },
    ]
  }
}
