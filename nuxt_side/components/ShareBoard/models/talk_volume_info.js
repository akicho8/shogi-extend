import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"

export class TalkVolumeInfo extends ApplicationMemoryRecord {
  static field_label = "申し伝え音量"
  static field_message = "これを 0 に設定するのは避けてください。実況の妨げになる場合は、「指し手の読み上げ」と「手番のお知らせ」だけを OFF にするのが適切です。これを 0 にしてしまうと重要な通知まで聞こえなくなり、想定のUXに支障をきたすおそれがあります（初期値: 0.5）"
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
