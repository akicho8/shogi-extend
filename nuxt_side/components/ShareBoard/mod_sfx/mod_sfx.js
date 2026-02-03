import { GX } from "@/components/models/gx.js"

import { howler_bug_reproduce        } from "./howler_bug_reproduce.js"
import { sb_audio_unlock_modal } from "./sb_audio_unlock_modal.js"

export const mod_sfx = {
  mixins: [
    howler_bug_reproduce,
    sb_audio_unlock_modal,
  ],

  methods: {
    // 意図して持ち上げた
    ev_action_piece_lift() {
      if (this.sp_mode === "play") {
        this.sfx_play("se_piece_lift")
      }
    },

    // 意図してキャンセルした
    ev_action_piece_cancel() {
      if (this.sp_mode === "play") {
        this.sfx_play("se_piece_lift_cancel")
      }
    },

    // 自分が指したときの駒音 (画面に反映されるのは次のフレームなのでずらす→やめ)
    se_piece_move() {
      this.sfx_play("se_piece_put", {volume_local_user_scale: this.volume_piece_user_scale})
      this.beat_call("short")
    },

    // スライダーを自分が動かしたときの音
    ev_action_turn_change_se() {
      this.sfx_click()
    },

    // スライダーを動かして数秒立って同期したときの音(自分にも伝えている→やめ)
    se_force_sync() {
      this.se_piece_move()
    },

    // ☗☖をタップして反転したときの音
    ev_action_viewpoint_flip() {
      if (this.sp_mode === "play") {
        this.sfx_click()
      }
    },

    // 成 or 不成 選択モードに入る
    ev_action_promote_select_open() {
      // this.sfx_play("se_piece_select")
    },

    // 成 or 不成 選択モードから出る
    ev_action_promote_select_close() {
    },

    ////////////////////////////////////////////////////////////////////////////////

    beat_call(type) {
      if (this.vibration_mode_info.key === "vibration_mode_on") {
        this.$beat.call(type)
      }
    },
  },
}
