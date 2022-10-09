import _ from "lodash"

export const app_kifu_mail = {
  methods: {
    // 確認方法: README_kifu_mail.org
    kifu_mail_handle() {
      this.$sound.play_click()
      // 部屋に入っているときは別ページに飛ぶと困るだろうから警告を出すに留める
      if (this.ac_room && !this.g_current_user) {
        this.toast_warn("ログインしてメールアドレスを適切に設定していると使えます")
        return
      }
      if (this.nuxt_login_required()) { return }
      this.kifu_mail_run()
    },
    kifu_mail_run(options = {}) {
      options = {
        silent: false,
        ...options,
      }
      const params = {
        source: this.current_sfen,
        turn: this.current_turn,
        title: this.current_title,
        abstract_viewpoint: this.abstract_viewpoint,
        ...this.player_names,
      }
      if (this.debug_mode_p) {
        params.__debug_app_urls__ = {
          share_board_url: this.room_code_except_url,
          piyo_url:        this.piyo_shogi_app_with_params_url,
          kento_url:       this.kento_app_with_params_url,
        }
      }
      this.$axios.$post("/api/share_board/kifu_mail.json", params, {progress: false}).then(e => {
        if (!options.silent) {
          this.toast_ok(e.message)
        }
      })
    },
  },
}
