import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"

export class ClockVolumeScaleInfo extends ApplicationMemoryRecord {
  static field_label   = "秒読み"
  // static field_message = "<span class='has-text-danger'>0 にしないでください。すると切れ負けが多発するでしょう (初期値: 0.5)</span>"
  static field_message = ""
  static input_type    = "slider"
  static min           = 0
  static step          = 1
  static max           = 10
  static ticks         = true

  static input_handle_callback(context, value) {
    const app = context.base
    GX.assert(app != null, "app != null")
    app.$nextTick(() => app.cc_notice("10秒…… 9…… 8…… 7……"))
  }

  static get define() {
    return [
    ]
  }
}
