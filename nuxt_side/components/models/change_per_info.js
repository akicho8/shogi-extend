import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChangePerInfo extends ApplicationMemoryRecord {
  static field_label = "N手毎交代"
  static field_message = "オンラインでは移動する手間がかからないため1手毎を推奨する"
  static input_type = "numberinput"
  static min = 1
  static max = 100
  static hint_messages = [
    "N回指したら交代します。リアル対局と違って移動の手間がかからないので1回にしておくのが無難です。",
  ]
  static get define() {
    return [
    ]
  }
}
