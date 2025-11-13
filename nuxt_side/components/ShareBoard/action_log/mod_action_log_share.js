export const mod_action_log_share = {
  methods: {
    //////////////////////////////////////////////////////////////////////////////// 共有版

    al_share_puts(label, options = {}) {
      this.al_share({
        label: label,
        message: `${this.user_call_name(this.my_call_name)}が${label}しました`,
        sfen: this.current_sfen, // 発動する側の棋譜を持っている
        turn: this.current_turn,
        ...options,
      })
    },

    al_share(params) {
      this.ac_room_perform("al_share", params) // --> app/channels/share_board/room_channel.rb
    },
    al_share_broadcasted(params) {
      this.al_add(params)
      if (params.message) {
        this.toast_ok(message)
      }
      this.ac_log({subject: "履歴追加", body: `「${params.label}」を受信`})
    },
  },
}
