import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"
import { VolumeCop } from "@/components/models/volume_cop.js"

export class VolumeCommonUserScaleInfo extends ApplicationMemoryRecord {
  static field_label      = "マスター"
  static field_message    = "全体の音量に対する倍率です。基本、触らないでください。0にすると駒音も消えてしまいます。実況の妨げになるのであれば「音響忌避者向け」を設定してください。"
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
