import { Gs } from "@/components/models/gs.js"

const TORYO_BGM_KEYS = [
  "bgm_ending1",
  "bgm_ending2",
  // "bgm_ending3",
  "bgm_ending4",
  // "bgm_ending5",
  // "bgm_ending6",
]

export const mod_sound_effect = {
  methods: {
    // 意図して持ち上げた
    ev_action_piece_lift() {
      if (this.sp_mode === "play") {
        this.$sound.play("se_piece_lift")
      }
    },
    // 意図してキャンセルした
    ev_action_piece_cancel() {
      if (this.sp_mode === "play") {
        this.$sound.play("se_piece_lift_cancel")
      }
    },
    // 自分が指したときの駒音 (画面に反映されるのは次のフレームなのでずらす→やめ)
    se_piece_move() {
      // this.$nextTick(() => {
      this.$sound.play("se_piece_put")
      this.beat_call("short")
      // })
    },
    // スライダーを自分が動かしたときの音
    ev_action_turn_change_se() {
      this.$sound.play_click()
    },
    // スライダーを動かして数秒立って同期したときの音(自分にも伝えている→やめ)
    se_force_sync() {
      this.$sound.play("se_piece_put")
      this.beat_call("short")
    },
    // ☗☖をタップして反転したときの音
    ev_action_viewpoint_flip() {
      if (this.sp_mode === "play") {
        this.$sound.play_click()
      }
    },
    // 成 or 不成 選択モードに入る
    ev_action_promote_select_open() {
      // this.$sound.play("se_piece_select")
    },
    // 成 or 不成 選択モードから出る
    ev_action_promote_select_close() {
    },

    ////////////////////////////////////////////////////////////////////////////////

    toryo_bgm_call() {
      if (TORYO_BGM_KEYS.length > 0) {
        Gs.assert(this.current_turn != null, "this.current_turn != null")
        const index = Gs.imodulo(this.current_turn, TORYO_BGM_KEYS.length)
        this.$sound.play(TORYO_BGM_KEYS[index])
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    beat_call(type) {
      if (this.vibration_mode_info.key === "vibration_mode_on") {
        this.$beat.call(type)
      }
    },
  },
}
