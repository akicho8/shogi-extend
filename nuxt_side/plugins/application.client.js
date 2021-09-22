import SnsLoginContainer from "@/components/SnsLoginContainer.vue"

export default {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    // タブが見えている状態か？
    // ブラウザ自体が非アクティブ状態(フォーカスされてない状態)でも true になる
    // つまり2窓で隣にYoutubeを開いてチャットを入力中であっても左側のブラウザは true になる
    // setInterval(() => console.log(this.tab_is_active_p()), 1000)
    tab_is_active_p() {
      return !this.tab_is_hidden_p()
    },

    // https://developer.mozilla.org/ja/docs/Web/API/Document/visibilityState
    // document.visibilityState は visible か hidden を返す
    tab_is_hidden_p() {
      // console.log("[hidden, visibilityState]", [document.hidden, document.visibilityState])
      return document.hidden || document.visibilityState === "hidden"
    },

    ////////////////////////////////////////////////////////////////////////////////

    sns_login_modal_open() {
      this.$buefy.modal.open({
        customClass: "my-modal-background-background-color-dark",
        width: "20rem",
        parent: this,
        component: SnsLoginContainer,
        animation: "",
        onCancel: () => this.sound_play("click"),
      })
    },

    sns_login_modal_handle() {
      this.sound_play("click")
      this.sns_login_modal_open()
    },

    ////////////////////////////////////////////////////////////////////////////////

    dialog_ok(message, options = {}) {
      options = {
        type: "info",
        talk: true,
        ...options,
      }
      if (options.talk) {
        this.talk(message, options)
      }
      this.$buefy.dialog.alert({
        title: options.title,
        type: `is-${options.type}`,
        // hasIcon: true,
        message: message,
        onConfirm: () => { this.sound_play("click") },
        onCancel:  () => { this.sound_play("click") },
      })
    },

    dialog_ng(message, params = {}) {
      params = {
        type: "danger",
        ...params,
      }
      this.dialog_ok(message, params)
    },

    //////////////////////////////////////////////////////////////////////////////// FIXME 冗長すぎる

    toast_ok(message, options = {}) {
      this.toast_primitive({message: message, ...options})
    },

    toast_warn(message, options = {}) {
      this.toast_primitive({message: message, type: "is-warning", ...options})
    },

    toast_ng(message, options = {}) {
      this.toast_primitive({message: message, type: "is-danger", ...options})
    },

    toast_primitive(params = {}) {
      params = {
        position: "is-bottom",
        type: "is-primary",
        queue: false,
        ...params,
      }
      if (params.message) {
        if (this.development_p) {
          this.clog(params.message)
        }

        if (!params.talk_only) {
          this.$buefy.toast.open(params)
        }
        if (!params.toast_only) {
          // volume, rate, onend は talk 用オプション
          this.talk(params.message, params)
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    error_message_dialog(message) {
      this.$buefy.dialog.alert({
        title: "失敗",
        message: message,
        canCancel: ["outside", "escape"],
        type: "is-danger",
        // size: "is-small",
        hasIcon: false,
        trapFocus: true,
        onConfirm: () => this.sound_play("click"),
        onCancel:  () => this.sound_play("click"),
      })
    },

    bs_error_message_dialog(attrs) {
      const { bs_error } = attrs
      if (bs_error) {
        let message = ""
        if (bs_error.message_prefix) {
          message += `<p>${bs_error.message_prefix}</p>`
        }
        if (bs_error.message) {
          message += `<p class="mt-2 is_line_break_on">${bs_error.message}</p>`
        }
        if (bs_error.board) {
          message += `<div class="mt-2 mb-0 error_message_pre has-background-white-ter box is-shadowless">${bs_error.board}</div>`
        }
        this.sound_play("x")
        this.error_message_dialog(message)
      }
    },

    notice_collector_has_error(response) {
      if (response) {
        const notice_collector = response.notice_collector
        if (notice_collector) {
          return notice_collector.has_error
        }
      }
    },

    notice_collector_run(response) {
      if (response) {
        const notice_collector = response.notice_collector
        if (notice_collector) {
          notice_collector.infos.forEach(e => this.notice_single_call(e))
        }
      }
    },

    notice_single_call(e) {
      if (false) {
      } else if (e.method === "dialog") {
        this.talk(e.message)
        this.$buefy.dialog.alert({
          title: e.title,
          type: `is-${e.type}`,
          hasIcon: true,
          message: e.message,
          onConfirm: () => { this.sound_play("click") },
          onCancel:  () => { this.sound_play("click") },
        })
      } else if (e.method === "toast") {
        this.toast_ok(e.message, {type: `is-${e.type}`})
      } else {
        throw new Error("must not happen")
      }
    },

    //////////////////////////////////////////////////////////////////////////////// modal

    modal_card_open(params) {
      this.__assert__(this.present_p(params.component), "this.present_p(params.component)")
      this.__assert__(this.present_p(params.component.name), "this.present_p(params.component.name)")
      return this.$buefy.modal.open({
        width: "", // width ではなく max-width に設定される
        customClass: `BasicModal ${params.component.name}`,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: ["outside", "escape"],
        onCancel: () => this.sound_play("click"),
        ...params,
      })
    },
  },
}
