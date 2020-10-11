export default {
  methods: {
    dialog_ok(message, options = {}) {
      options = {
        type: "info",
        ...options,
      }
      this.talk(message, options)
      this.$buefy.dialog.alert({
        title: options.title,
        type: `is-${options.type}`,
        hasIcon: true,
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
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-dark", queue: false, ...options})
      this.talk(message)
    },

    toast_ng(message, options = {}) {
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-danger", queue: false, ...options})
      this.talk(message)
    },

    error_message_dialog(message) {
      this.$buefy.dialog.alert({
        title: "ERROR",
        message: message,
        canCancel: ["outside", "escape"],
        type: "is-danger",
        hasIcon: true,
        trapFocus: true,
        onConfirm: () => { this.sound_play("click") },
        onCancel:  () => { this.sound_play("click") },
      })
    },

    bs_error_message_dialog(bs_error) {
      const message = `
          <div>${bs_error.message_prefix}</div>
          <div>${bs_error.message}</div>
          <div class="error_message_pre mt-2 has-background-white-ter box is-shadowless">${bs_error.board}</div>
        `
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
        this.talk(e.title)
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
