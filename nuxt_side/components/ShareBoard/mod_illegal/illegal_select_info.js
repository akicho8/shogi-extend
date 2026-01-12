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
          context.current_sfen_set(context.illegal_params)

          // 「投了」を押した人だけが投了する
          if (context.received_from_self(params)) {
            context.resign_call({ending_route_key: "er_manual_illegal"})
          }
        },
      },
      {
        key: "do_takeback",
        name: "待った",
        call: (context, params) => {
          // 全員にメッセージを表示する
          context.toast_primary(params.takebacked_message)

          // 「待った」を押した人だけ時計を再開する
          if (context.received_from_self(params)) {
            context.cc_resume_silent_share()
          }
        },
      },
    ]
  }
}
