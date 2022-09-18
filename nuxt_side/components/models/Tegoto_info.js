import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TegotoInfo extends ApplicationMemoryRecord {
  static field_label = "N手毎交代"
  static message = null
  static input_type = "numberinput"
  static min = 1
  static max = 10
  static hint_messages = [
    "1人10手毎交代のようなルールにできます。",
    "ただそれは席の移動で慌しくなるのを心配したテレビ用のルールと考えられるためオンラインなら1手毎交代がおすすめです",
  ]
  static get define() {
    return [
    ]
  }
}
