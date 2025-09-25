import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"

export class ClockVolumeInfo extends ApplicationMemoryRecord {
  static field_label   = "秒読み音量"
  static field_message = "<span class='has-text-danger'>0 にしないでください。すると切れ負けが多発するでしょう (初期値: 0.5)</span>"
  static input_type    = "slider"
  static min           = 0.0
  static step          = 0.1
  static max           = 1.0

  static input_handle_callback(context, value) {
    const app = context.base
    Gs.assert(app != null, "app != null")
    app.$nextTick(() => app.cc_talk(value))
  }

  static get define() {
    return [
    ]
  }
}
