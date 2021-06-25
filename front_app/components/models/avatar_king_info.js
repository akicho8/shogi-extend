import MemoryRecord from 'js-memory-record'

export class AvatarKingInfo extends MemoryRecord {
  static get message() { return "ﾌﾟﾛﾌ画像が玉になる" }

  static get define() {
    return [
      { key: "is_avatar_king_off", name: "なし", message: null, },
      { key: "is_avatar_king_on",  name: "あり", message: null, },
    ]
  }
}
