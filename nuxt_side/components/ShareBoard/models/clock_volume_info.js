import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"

export class ClockVolumeInfo extends ApplicationMemoryRecord {
  static field_label   = "秒読み音量"
  static field_message = "うっかり切れ負けしてしまう人は大きめにしておこう。0 にして実況すると対局の緊張感が損なわれます。（初期値: 0.5）"
  static input_type    = "slider"
  static min           = 0.0
  static step          = 0.1
  static max           = 1.0

  static input_handle_callback(context, value) {
    const app = context.base
    Gs.assert(app != null, "app != null")
    app.$nextTick(() => app.cc_talk(value))
  }

  static get define() {
    return [
    ]
  }
}
