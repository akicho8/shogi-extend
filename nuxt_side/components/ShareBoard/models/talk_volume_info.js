import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"

export class TalkVolumeInfo extends ApplicationMemoryRecord {
  static field_label = "システム音量"
  // 実況の妨げになる場合は、「指し手の読み上げ」と「手番のお知らせ」だけを OFF にしてください
  static field_message = "<span class='has-text-danger'>0 にしないでください。想定のUXに支障をきたします (初期値: 0.5)</span>"
  static input_type = "slider"
  static min = 0.0
  static step = 0.1
  static max = 1.0

  static input_handle_callback(context, value) {
    const app = context.base
    Gs.assert(app != null, "app != null")
    app.$nextTick(() => app.sb_talk(value))
  }

  static get define() {
    return [
    ]
  }
}
