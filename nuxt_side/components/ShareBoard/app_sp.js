export const app_sp = {
  methods: {
    // ShogiPlayer コンポーネント自体を実行したいとき用
    sp_call(func) {
      return func(this.$refs.ShareBoardSp.$refs.main_sp.sp_object())
    },

    // 持駒を元に戻す(デバッグ用)
    sp_state_reset() {
      return this.sp_call(e => e.state_reset())
    },

    // 駒箱調整
    sp_piece_box_piece_counts_adjust() {
      return this.sp_call(e => e.mediator.piece_box_piece_counts_adjust())
    },

    // 玉の自動配置
    sp_king_formation_auto_set_on_off(v) {
      return this.sp_call(e => e.mediator.king_formation_auto_set_on_off(v))
    }
  },
}
