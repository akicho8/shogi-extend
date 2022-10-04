export const app_sound_effect = {
  methods: {
    // 自分が指したときの駒音 (画面にされるのは次のフレームなのでずらす)
    se_user_piece_put() {
      this.$nextTick(() => {
        this.sound_play("piece_put")
        this.vibrate_short()
      })
    },
    // スライダーを自分が動かしたときの音
    se_user_turn_change() {
      this.sound_play_click()
      this.vibrate_short()
    },
    // スライダーを動かして数秒立って同期したときの音(自分にも伝えている)
    se_force_sync() {
      this.sound_play("piece_put")
      this.vibrate_short()
    },
    // ☗☖をタップして反転したときの音
    se_user_viewpoint_flip() {
      this.sound_play_click()
      this.vibrate_short()
    },
  },
}
