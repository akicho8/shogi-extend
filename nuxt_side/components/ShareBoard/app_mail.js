import _ from "lodash"

export const app_mail = {
  methods: {
    // 確認方法
    // ・http://localhost:3000/api/share_board/kifu_notify.json
    // ・http://localhost:4000/share-board?autoexec=mail_handle
    mail_handle() {
      // this.remote_notify({emoji: ":外部アプリ:", subject: "共有将棋盤→外部アプリ起動", body: app_name})
      const params = {
        source: this.current_sfen,
        turn: this.current_turn,
        title: this.current_title,
        ...this.player_names,
        app_urls: {
          share_board_url: this.room_code_except_url,
          piyo_url:        this.piyo_shogi_app_with_params_url,
          kento_url:       this.kento_app_with_params_url,
        },
      }
      this.toast_ok("mail")
      return this.$axios.$post("/api/share_board/kifu_notify.json", params, {progress: false})
    },
  },
  computed: {
  },
}
