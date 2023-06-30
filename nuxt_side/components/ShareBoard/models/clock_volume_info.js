import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"

export class ClockVolumeInfo extends ApplicationMemoryRecord {
  static field_label = "秒読み音量"
  static field_message = ""
  static input_type = "slider"
  static min = 0
  static max = 20

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
