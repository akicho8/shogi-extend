import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"
import { VolumeCop } from "@/components/models/volume_cop.js"

export class VolumePieceUserScaleInfo extends ApplicationMemoryRecord {
  static field_label   = "駒音"
  static field_message = "UXの意図を汲み取れる感性をお持ちであれば無音にしないはずだと信じている"
  static input_type    = "slider"
  static min           = VolumeCop.CONFIG.user_scale_min
  static max           = VolumeCop.CONFIG.user_scale_max
  static step          = 1
  static ticks         = true

  static input_handle_callback(context, value) {
    const app = context.base
    GX.assert(app != null, "app != null")
    app.$nextTick(() => app.se_piece_move())
  }

  static get define() {
    return [
    ]
  }
}
