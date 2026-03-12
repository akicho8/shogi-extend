import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"
import { VolumeCop } from "@/components/models/volume_cop.js"

export class VolumeClockUserScaleInfo extends ApplicationMemoryRecord {
  static field_label      = "秒読み"
  static field_message    = "切れ負けが多発するため無音にするのはおすすめしません。"
  static input_type       = "slider"
  static min              = VolumeCop.CONFIG.user_scale_min
  static max              = VolumeCop.CONFIG.user_scale_max
  static step             = 1
  static ticks            = true

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
