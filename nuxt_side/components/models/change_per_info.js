import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChangePerInfo extends ApplicationMemoryRecord {
  static field_label = "X手指したら交代する"
  static field_message = "長い手番待ちを避けるため<b>1手ごとの進行を推奨</b>します"
  static input_type = "numberinput"
  static min = 1
  static max = 999
  static hint_messages = [
    // "リアル対局と違い移動の手間がかからないため1手毎を推奨する",
  ]
  static get define() {
    return [
    ]
  }
}
