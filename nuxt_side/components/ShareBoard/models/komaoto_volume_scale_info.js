import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"

export class KomaotoVolumeScaleInfo extends ApplicationMemoryRecord {
  static field_label   = "駒音"
  // static field_message = "音を立てるのは失礼である派は小さくすべし (初期値: 5)" // ::SE_PIECE_PUT_VOLUME::
  static field_message = "" // ::SE_PIECE_PUT_VOLUME::
  static input_type    = "slider"
  static min           = 0
  static step          = 1
  static max           = 20
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
