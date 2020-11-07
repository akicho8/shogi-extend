import SnsLoginContainer         from "@/components/SnsLoginContainer.vue"

export default {
  methods: {
    sns_login_modal_handle() {
      this.$buefy.modal.open({
        customClass: "my-modal-background-background-color-dark",
        width: "20rem",
        parent: this,
        component: SnsLoginContainer,
        animation: "",
        onCancel: () => this.sound_play("click"),
      })
    },

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

    toast_ok(message, options = {}) {
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-primary", queue: false, ...options})
      this.talk(message)
    },

    toast_warn(message, options = {}) {
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-warning", queue: false, ...options})
      this.talk(message)
    },

    toast_ng(message, options = {}) {
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-danger", queue: false, ...options})
      this.talk(message)
    },

    error_message_dialog(message) {
      this.$buefy.dialog.alert({
        message: message,
        canCancel: ["outside", "escape"],
        type: "is-danger",
        size: "is-small",
        hasIcon: false,
        trapFocus: true,
        onConfirm: () => this.sound_play("click"),
        onCancel:  () => this.sound_play("click"),
      })
    },

    bs_error_message_dialog(bs_error, append_message = "") {
      let message = ""
      if (bs_error.message_prefix) {
        message += `<p>${bs_error.message_prefix}</p>`
      }
      if (bs_error.message) {
        message += `<p class="mt-2">${bs_error.message}</p>`
      }
      if (bs_error.board) {
        message += `<div class="mt-2 mb-0 error_message_pre has-background-white-ter box is-shadowless">${bs_error.board}</div>`
      }
      if (append_message) {
        message += append_message
      }
      this.sound_play("x")
      this.error_message_dialog(message)
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
  },
}
