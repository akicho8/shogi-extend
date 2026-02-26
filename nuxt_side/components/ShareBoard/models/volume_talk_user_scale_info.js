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
    const message = `それでは${app.my_call_name}から指してください`
    app.$nextTick(() => app.toast_primary(message))
  }
}
