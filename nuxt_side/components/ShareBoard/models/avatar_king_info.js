import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AvatarKingInfo extends ApplicationMemoryRecord {
  static field_label = "アバター"
  static message = null
  static hint_messages = [
    "自分のアバターを玉として表示します。",
    "複数人いる場合はリーダーのアバターを使います。",
    "対局中でも順番設定で無効にできます。",
    "ログインしているとプロフィール編集から自由に変更できます。",
  ]

  static get define() {
    return [
      { key: "is_avatar_king_off", name: "なし", message: "普通に駒を表示", },
      { key: "is_avatar_king_on",  name: "あり", message: "自分が玉になる", },
    ]
  }
}
