export const application_new_challenge = {
  data() {
    return {
      snackbar_instances: [],
    }
  },

  methods: {
    // ブロードキャストされた内容から通知してよいか判断する
    new_challenge_facade(params) {
      if (params.trigger === "add") {
        // マッチング開始
        this.__assert__(params.user && params.user.id, "params.user && params.user.id")

        if (params.user.id === this.current_user.id) {
          this.clog("[挑戦者現る] 自分が開始した通知が自分に届いたので通知しない")
          return
        }
        if (this.tab_is_hidden_p()) {
          this.clog("[挑戦者現る] 他の人に届いたけどタブがアクティブになっていないため通知しない")
          return
        }
        if (this.tab_is_hidden_p()) {
          this.clog("[挑戦者現る] 他の人に届いたけどタブがアクティブになっていないため通知しない")
          return
        }
        if (this.mode === "lobby" || this.mode === "battle") {
          // 通知有効
        } else {
          this.clog("[挑戦者現る] ロビーか練習中でないため通知しない")
          return
        }

        this.new_challenge_notify(params)
      }

      if (params.trigger === "delete") {
        // マッチングキャンセル
      }

      if (params.trigger == null) {
        // マッチングの待機中の通知
      }
    },

    // private

    // 挑戦者通知
    new_challenge_notify(params) {
      this.sound_play("new_challenge")

      const message = this.new_challenge_message(params)
      this.say("挑戦者現る。対戦しますか？")

      const snackbar_instance = this.$buefy.snackbar.open({
        duration: params.duration || 8 * 1000,
        message: message,
        type: "is-success",
        position: "is-bottom-left",
        actionText: "対戦する",
        queue: false,
        onAction: () => {
          this.sound_play("click")
          this.new_challenge_accept_handle(params)
        }
      })

      this.snackbar_instances.push(snackbar_instance)
    },

    // すべて消す
    new_challenge_snackbar_clear() {
      this.snackbar_instances.forEach(e => e.close())
      this.snackbar_instances = []
    },

    // 挑戦者通知→対戦する
    new_challenge_accept_handle(params) {
      this.revision_safe(() => {
        const api_params = {
          user_id: params.user.id,
          rule_key: params.rule_key,
          session_lock_token: this.current_user.session_lock_token, // マッチング通知を自分だけに行うための識別子を送る
        }

        this.api_put("new_challenge_accept_handle", api_params, e => {
          this.debug_alert(e.status)
          if (e.status === "success") {
            this.ok_notice(e.message)
          }
          if (e.status === "opponent_missing") {
            this.warning_notice(e.message)
          }
        }) // --> app/models/frontend_script/actb_app_script/put_api.rb
      })
    },

    // snackbar 用のメッセージ
    new_challenge_message(params) {
      const rule_info = this.RuleInfo.fetch(params.rule_key)

      if (this.development_p) {
        if (!params.user.avatar_path) {
          params.user.avatar_path = "http://localhost:3000/assets/human/0005_fallback_avatar_icon-f076233f605139a9b8991160e1d79e6760fe6743d157446f88b12d9dae5f0e03.png"
        }
      }

      let figure = ""
      let message = ""

      if (params.user.avatar_path) {
        figure += `
          <figure class="image is-64x64 avatar_image">
            <img src="${params.user.avatar_path}" class="is-rounded" />
          </figure>`
      }

      if (true) {
        if (true) {
          message += `${params.user.name}さんがマッチングを開始しました`
        } else {
          message += `挑戦者現る！`
        }
        message += `<br/>`
        if (this.room) {
          message += `練習をキャンセルして対戦しますか？`
        } else {
          message += `対戦しますか？`
        }
        message += ` (${rule_info.name})`
        message = `<div class="ml-2">${message}</div>`
      }

      // app/javascript/actb_app/application.sass で別定義あり
      return `<div class="actb_app new_challenge_message is-flex">
               ${figure}${message}
              </div>`
    },
  }
}
