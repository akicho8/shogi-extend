import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class HowlHtml5Info extends ApplicationMemoryRecord {
  static field_label = "再生方法"
  static field_message = ""

  static get define() {
    return [
      { key: "is_howl_html5_off", name: "OFF", type: "is-primary", message: null, },
      { key: "is_howl_html5_on",  name: "ON",  type: "is-danger",  message: null, },
    ]
  }
}
