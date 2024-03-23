export const mod_sound_effect = {
  methods: {
    // 意図して持ち上げた
    ev_action_piece_lift() {
      if (this.sp_mode === "play") {
        this.$sound.play_click()
      }
    },
    // 意図してキャンセルした
    ev_action_piece_cancel() {
      if (this.sp_mode === "play") {
        this.$sound.play_click()
      }
    },
    // 自分が指したときの駒音 (画面に反映されるのは次のフレームなのでずらす)
    se_piece_move() {
      this.$nextTick(() => {
        this.$sound.play("piece_put")
        this.beat_call("short")
      })
    },
    // スライダーを自分が動かしたときの音
    ev_action_turn_change_se() {
      this.$sound.play_click()
    },
    // スライダーを動かして数秒立って同期したときの音(自分にも伝えている)
    se_force_sync() {
      this.$sound.play("piece_put")
      this.beat_call("short")
    },
    // ☗☖をタップして反転したときの音
    ev_action_viewpoint_flip() {
      if (this.sp_mode === "play") {
        this.$sound.play_click()
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
