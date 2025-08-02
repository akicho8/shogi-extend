import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"

export class MoveVolumeInfo extends ApplicationMemoryRecord {
  static field_label   = "パチン音量"
  static field_message = "いちいち音を立てるのは失礼である派は小さくしよう。実況時など指したタイミングをわかりやすくしたい場合は大きめにしよう。（初期値: 0.3）" // ::SE_PIECE_PUT_VOLUME::
  static input_type    = "slider"
  static min           = 0.0
  static step          = 0.1
  static max           = 1.0

  static input_handle_callback(context, value) {
    const app = context.base
    Gs.assert(app != null, "app != null")
    app.$nextTick(() => app.se_piece_move())
  }

  static get define() {
    return [
    ]
  }
}
