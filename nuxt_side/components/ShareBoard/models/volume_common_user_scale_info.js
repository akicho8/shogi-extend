import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"
import { VolumeCop } from "@/components/models/volume_cop.js"

export class VolumeCommonUserScaleInfo extends ApplicationMemoryRecord {
  static field_label      = "マスター"
  static field_message    = "基本、触らないでよいです。0にすると駒音もなくなります。実況の妨げになるのであれば、まずは「通知」を設定してください。"
  static input_type       = "slider"
  static min              = VolumeCop.CONFIG.user_scale_min
  static max              = VolumeCop.CONFIG.user_scale_max
  static step             = 1
  static ticks            = true

  static input_handle_callback(context, value) {
    const app = context.base
    GX.assert(app != null, "app != null")
    app.$nextTick(() => app.toast_primary(`マスター音量${value}`))
  }

  static get define() {
    return [
    ]
  }
}
