import { GX } from "@/components/models/gx.js"

export const vue_dialog = {
  methods: {
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
        onConfirm: () => { this.sfx_click() },
        onCancel:  () => { this.sfx_click() },
      })
    },

    dialog_ng(message, params = {}) {
      params = {
        type: "danger",
        ...params,
      }
      this.dialog_ok(message, params)
    },

    ////////////////////////////////////////////////////////////////////////////////

    toast_ok(message, options = {}) {
      return this.toast_primitive(message, {type: "is-primary", ...options})
    },

    toast_warn(message, options = {}) {
      return this.toast_primitive(message, {type: "is-warning", ...options})
    },

    toast_ng(message, options = {}) {
      return this.toast_primitive(message, {type: "is-danger", ...options})
    },

    async toast_primitive(message, params = {}) {
      params = {
        toast: true,
        talk: true,
        position: "is-bottom",
        type: "is-primary",
        queue: false,
        ...params,
      }
      if (message) {
        if (this.development_p) {
          this.clog(message)
        }
        const h = GX.hash_extract_self(params, "toast", "talk", "duration_sec")
        if (h.duration_sec) {
          GX.assert_kind_of_numeric(h.duration_sec)
          GX.assert(h.duration_sec < 1000)
          GX.assert(params.duration == null)
          params.duration = h.duration_sec * 1000.0
        }
        if (h.toast) {
          this.$buefy.toast.open({...params, message: message})
        }
        if (h.talk) {
          return this.talk(message, params) // volume, rate, onend は talk 用オプション
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    error_message_dialog(message, params = {}) {
      this.dialog_alert({
        message: message,
        title: "失敗",
        type: "is-danger",
        canCancel: ["outside", "escape"],
        ...params,
      })
    },

    bs_error_message_dialog(attrs) {
      const { bs_error } = attrs
      if (bs_error) {
        let message = ""
        if (bs_error.message_prefix) {
          message += `<div>${bs_error.message_prefix}</div>`
        }
        if (bs_error.message) {
          message += `<div class="is_line_break_on">${bs_error.message}</div>`
        }
        if (bs_error.board) {
          message += `<div class="mb-0 error_message_pre has-background-white-ter box is-shadowless">${bs_error.board}</div>`
        }
        this.sfx_play("x")
        this.error_message_dialog(message)
      }
    },

    //////////////////////////////////////////////////////////////////////////////// Xnotice

    xnotice_has_error_p(response) {
      if (response) {
        const xnotice = response.xnotice
        if (xnotice) {
          return xnotice.has_error_p
        }
      }
    },

    xnotice_run_all(response) {
      if (response) {
        const xnotice = response.xnotice
        if (xnotice) {
          xnotice.infos.forEach(e => this.xnotice_run(e))
        }
      }
    },

    xnotice_run(e) {
      if (e.method === "dialog") {
        this.talk(e.message)
        this.dialog_alert(e)
      } else if (e.method === "toast") {
        const options = {
          type: e.type,
        }
        if (e.duration_sec) {
          options.duration_sec = e.duration_sec
        }
        this.toast_ok(e.message, options)
      } else {
        throw new Error("must not happen")
      }
    },

    //////////////////////////////////////////////////////////////////////////////// modal

    modal_card_open(params) {
      GX.assert(GX.present_p(params.component), "GX.present_p(params.component)")
      GX.assert(GX.present_p(params.component.name), "GX.present_p(params.component.name)")
      return this.$buefy.modal.open({
        width: "", // width ではなく max-width に設定される
        customClass: `BasicModal ${params.component.name}`,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        scroll: "keep",
        animation: "",
        canCancel: ["outside", "escape"],
        onCancel: () => this.sfx_click(),
        ...params,
      })
    },

    dialog_prompt(params = {}) {
      return this.$buefy.dialog.prompt({
        title: null,
        confirmText: "更新",
        cancelText: "キャンセル",
        animation: "",
        inputAttrs: { type: "text", value: "", required: false },
        onCancel: () => this.sfx_click(),
        onConfirm: value => {
          this.debug_alert(value)
          this.sfx_click()
        },
        ...params,
      })
    },

    // https://buefy.org/documentation/dialog
    // focusOn の初期値は "confirm"
    dialog_confirm(params = {}) {
      return this.$buefy.dialog.confirm({
        message: "本当によいですか？",
        cancelText: "キャンセル",
        animation: "",
        onCancel: () => this.sfx_click(),
        onConfirm: () => this.sfx_click(),
        ...params,
      })
    },

    dialog_alert(params = {}) {
      return this.$buefy.dialog.alert({
        animation: "",
        confirmText: "OK",
        onConfirm: () => this.sfx_click(),
        ...params,
      })
    },
  },
}
