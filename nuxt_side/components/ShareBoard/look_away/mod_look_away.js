import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import { window_activity_detector } from "./window_activity_detector.js"

export const mod_look_away = {
  mixins: [
    window_activity_detector,
  ],
  methods: {
    window_activity_change_fn(active_p) {
      if (this.__SYSTEM_TEST_RUNNING__) {
      } else {
        this.debug_alert(`画面:${active_p}`)
      }
      this.tl_add("画面焦点", active_p ? "ON" : "OFF")
      this.ac_log({subject: "画面焦点", body: active_p ? "ON" : "OFF"})

      if (active_p) {
        // PC の場合はよそ見中であってもチャットを受信するのでモバイルのときだけとしてもいいが、スマホが多数派なので分けないでいい
        this.mh_window_focus()
      }

      if (active_p) {
        if (this.mobile_p) {
          this.sound_resume_modal_handle()
        }
      }

      this.member_bc_restart() // インターバル実行の再スタートで即座にメンバー情報を反映する

      if (!active_p) {
        this.xmatch_window_blur() // ウィンドウを離れたらエントリー解除する
      }
    },
  },
}
