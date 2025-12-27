import { GX } from "@/components/models/gx.js"
import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class IllegalSelectInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "do_resign",
        name: "投了する",
        call: (context, params) => {
          // 全員の局面を反則局面に変更する
          context.current_sfen_set(params)

          // 最後に YES を押した人だけが投了する
          if (context.received_from_self(params)) {
            context.resign_call()
          }
        },
      },
      {
        key: "do_takeback",
        name: "待った",
        call: (context, params) => {
          // 時計が pause 状態になっているので「なかったことにする」のであれば再開する
          context.cc_resume_handle()
          context.al_add({...params, label: "対局再開", label_type: "is-primary"})

          // 状況表示
          context.toast_primary(params.takebacked_message)
        },
      },
    ]
  }
}
