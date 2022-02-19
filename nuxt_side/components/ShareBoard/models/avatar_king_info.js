import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AvatarKingInfo extends ApplicationMemoryRecord {
  static field_label = "アバター"
  static message = null
  static hint_messages = [
    "自分のアバターを玉として表示します。",
    "複数人いる場合は最初に指す人のアバターを使います。",
    "ログインしているとプロフィールで編集できます。",
  ]

  static get define() {
    return [
      { key: "is_avatar_king_off", name: "なし", message: "普通に駒を表示", },
      { key: "is_avatar_king_on",  name: "あり", message: "自分が玉になる", },
    ]
  }
}
