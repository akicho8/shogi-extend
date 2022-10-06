export const app_kifu_copy_buttons = {
  methods: {
    // 指定の解答の「ぴよ将棋」へのリンク
    answers_piyo_shogi_app_with_params_url(moves_answer) {
      return this.piyo_shogi_auto_url({
        turn: 0,
        sfen: this.current_article.init_sfen_with(moves_answer),
        viewpoint: this.current_article.viewpoint,
      })
    },

    // 指定の解答の「KENTO」へのリンク
    answers_kento_app_with_params_url(moves_answer) {
      return this.kento_full_url({
        turn: 0,
        sfen: this.current_article.init_sfen_with(moves_answer),
        viewpoint: this.current_article.viewpoint,
      })
    },

    // 指定の解答のコピー処理
    answers_kifu_copy_handle(moves_answer) {
      this.$sound.play_click()
      this.general_kifu_copy(this.current_article.init_sfen_with(moves_answer), {to_format: "kif"})
    },
  },
}
