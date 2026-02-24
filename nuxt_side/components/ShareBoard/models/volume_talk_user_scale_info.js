import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"
import { VolumeCop } from "@/components/models/volume_cop.js"

export class VolumeTalkUserScaleInfo extends ApplicationMemoryRecord {
  static field_label      = "UX音声"
  static field_message    = "どうしても実況の妨げになるのであれば少し下げてください。無音はユーザー体験に支障が出ます。"
  static input_type       = "slider"
  static min              = VolumeCop.CONFIG.user_scale_min
  static max              = VolumeCop.CONFIG.user_scale_max
  static step             = 1
  static ticks            = true

  static input_handle_callback(context, value) {
    const app = context.base
    GX.assert(app != null, "app != null")
    let message = null
    if (GX.present_p(app.user_name)) {
      message = `${app.user_call_name(app.user_name)}、こんにちは`
    } else {
      message = "こんにちは"
    }
    app.$nextTick(() => app.toast_primary(message))
  }

  static get define() {
    return [
    ]
  }
}
