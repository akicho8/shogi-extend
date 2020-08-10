export const application_new_challenge = {
  methods: {
    // 挑戦者通知
    new_challenge_notify(rule_name) {
      this.sound_play("bell1")

      let message = `${rule_name}に挑戦者現る！<br>`
      if (this.room) {
        message += `練習をキャンセルして対戦しますか？`
      } else {
        message += `対戦しますか？`
      }
      this.say(message)

      this.$buefy.snackbar.open({
        duration: 15 * 1000,
        message: message,
        type: "is-success",
        position: "is-bottom-left",
        actionText: "対戦する",
        queue: false,
        onAction: () => {
          this.sound_play("click")
          this.new_challenge_accept_handle()
        }
      })
    },

    // 挑戦者通知→対戦する
    new_challenge_accept_handle() {
      this.revision_safe(() => {
        // --> app/models/frontend_script/actb_app_script/put_api.rb
        this.api_put("new_challenge_accept_handle", {session_lock_token: this.current_user.session_lock_token}, e => {
          this.debug_alert(e.status)
          if (e.status === "success") {
            this.ok_notice("マッチング成功！")
          }
          if (e.status === "opponent_missing") {
            this.warning_notice("相手がすでに対人戦を開始したか抜けてしまいました")
          }
        })
      })
    },
  }
}
