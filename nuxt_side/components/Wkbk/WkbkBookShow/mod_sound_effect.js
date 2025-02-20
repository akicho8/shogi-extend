export const mod_sound_effect = {
  methods: {
    // 意図して持ち上げた
    ev_action_piece_lift() {
      this.$sound.play_click()
    },
    // 意図してキャンセルした
    ev_action_piece_cancel() {
      this.$sound.play_click()
    },
    // 自分が指したときの駒音 (画面にされるのは次のフレームなのでずらす)
    ev_play_mode_move() {
      this.$nextTick(() => {
        this.$sound.play_click()
        // this.$sound.play("se_piece_put"),
      })
    },
    // スライダーを自分が動かしたときの音
    ev_action_turn_change() {
      this.$sound.play_click()
    },
    // ☗☖をタップして反転したときの音
    ev_action_viewpoint_flip() {
      this.$sound.play_click()
    },
  },
}
