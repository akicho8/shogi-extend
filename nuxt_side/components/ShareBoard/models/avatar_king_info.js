import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AvatarKingInfo extends ApplicationMemoryRecord {
  static field_label = "アバター"
  static message = null

  static get define() {
    return [
      { key: "is_avatar_king_off", name: "なし", message: "普通に駒を表示", },
      { key: "is_avatar_king_on",  name: "あり", message: "自分が玉になる", },
    ]
  }
}
