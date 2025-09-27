import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"

export class TalkVolumeScaleInfo extends ApplicationMemoryRecord {
  static field_label = "音声"
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
    let message = null
    if (Gs.present_p(app.user_name)) {
      message = `${app.user_call_name(app.user_name)}、こんにちは`
    } else {
      message = "こんにちは"
    }
    app.$nextTick(() => app.toast_ok(message))
  }

  static get define() {
    return [
    ]
  }
}
