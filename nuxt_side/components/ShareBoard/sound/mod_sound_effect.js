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

    ////////////////////////////////////////////////////////////////////////////////

    toryo_bgm_call() {
      this.$sound.play_random([
        "bgm_battle_toryo1",
        "bgm_battle_toryo2",
        "bgm_battle_toryo3",
        "bgm_battle_toryo4",
        "bgm_battle_toryo5",
      ])
    },

    ////////////////////////////////////////////////////////////////////////////////

    beat_call(type) {
      if (this.vibration_mode_info.key === "vibration_mode_on") {
        this.$beat.call(type)
      }
    },
  },
}
