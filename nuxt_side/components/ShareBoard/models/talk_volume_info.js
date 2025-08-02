import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"

export class TalkVolumeInfo extends ApplicationMemoryRecord {
  static field_label = "おしゃべり音量"
  static field_message = "実況などで対局中に静かにさせたい場合は、これを 0 に設定するのではなく、「指し手の読み上げ」と「手番のお知らせ」だけを OFF にするのが適切です。0 にしてしまうと、チャットの発言や各種操作通知など、ほとんどの音声が再生されなくなります。"
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
