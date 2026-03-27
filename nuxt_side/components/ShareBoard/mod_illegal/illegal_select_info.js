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
          // illegal_takeback_modal_start_broadcasted のところですでに反映しているためなくてもよい
          context.current_sfen_set(context.illegal_params)

          // 「投了」を押した人だけが投了する
          if (context.received_from_self(params)) {
            context.resign_action({
              ending_route_key: "er_user_illegal_resign",
              choker_user_name: context.illegal_params.from_user_name, // 戦犯者
              resigned_user_name: context.user_name, // 投了者
              illegal_hv_list: params.illegal_hv_list,
            })
          }
        },
      },
      {
        key: "do_takeback",
        name: "待った",
        call: (context, params) => {
          // 全員にメッセージを表示する
          context.toast_primary(params.takebacked_message)

          // 全員が自分で1手戻す
          if (context.current_turn > 0) {
            context.current_turn -= 1
          }

          // 「待った」を押した人だけ時計を再開する
          if (context.received_from_self(params)) {
            context.cc_resume_silent_share()
          }
        },
      },
    ]
  }
}
