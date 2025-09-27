import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"

export class CommonVolumeScaleInfo extends ApplicationMemoryRecord {
  static field_label = "マスター"
  // static field_message = "<span class='has-text-danger'>0 にしないでください。想定のUXに支障をきたします (初期値: 5)</span>"
  static field_message = ""
  static input_type = "slider"
  static min = 0.0
  static step = 1
  static max = 10
  static ticks = true

  static input_handle_callback(context, value) {
    const app = context.base
    Gs.assert(app != null, "app != null")
    app.$nextTick(() => app.toast_ok(`マスター音量${value}`))
  }

  static get define() {
    return [
    ]
  }
}
