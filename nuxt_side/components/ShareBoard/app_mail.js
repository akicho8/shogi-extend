import _ from "lodash"

export const app_mail = {
  methods: {
    // 確認方法
    // ・http://localhost:3000/api/share_board/remote_notify2.json
    // ・http://localhost:4000/share-board?autoexec=mail_handle
    mail_handle() {
      // this.remote_notify({emoji: ":外部アプリ:", subject: "共有将棋盤→外部アプリ起動", body: app_name})
      const params = {
        sfen: this.current_sfen,
        turn: this.current_turn,
        title: this.current_title,
        ...this.player_names,
        url: this.room_code_except_url,
      }
      this.toast_ok("mail")
      return this.$axios.$post("/api/share_board/remote_notify2.json", params, {progress: false})
    },
  },
  computed: {
  },
}
