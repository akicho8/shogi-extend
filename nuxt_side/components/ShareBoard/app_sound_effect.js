export const app_sound_effect = {
  methods: {
    // 意図して持ち上げた
    se_user_piece_lift() {
      this.sound_play_click()
    },
    // 意図してキャンセルした
    se_user_piece_cancel() {
      this.sound_play_click()
    },
    // 自分が指したときの駒音 (画面にされるのは次のフレームなのでずらす)
    se_user_piece_put() {
      this.$nextTick(() => {
        this.sound_play("piece_put")
        this.$beat.call_short()
      })
    },
    // スライダーを自分が動かしたときの音
    se_user_turn_change() {
      this.sound_play_click()
    },
    // スライダーを動かして数秒立って同期したときの音(自分にも伝えている)
    se_force_sync() {
      this.sound_play("piece_put")
      this.$beat.call_short()
    },
    // ☗☖をタップして反転したときの音
    se_user_viewpoint_flip() {
      this.sound_play_click()
    },
  },
}
