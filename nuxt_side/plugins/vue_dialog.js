import { GX } from "@/components/models/gx.js"
import { ToastInfo } from "@/components/models/toast_info.js"
import BioshogiErrorModal from "@/components/BioshogiErrorModal.vue"

export const vue_dialog = {
  methods: {
    g_toast_key_reset() {
      this.g_toast_key = null
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

    toast_primary(message, options = {}) {
      return this.toast_primitive(message, {type: "is-primary", ...options})
    },

    toast_warn(message, options = {}) {
      return this.toast_primitive(message, {type: "is-warning", ...options})
    },

    toast_danger(message, options = {}) {
      return this.toast_primitive(message, {type: "is-danger", ...options})
    },

    async toast_primitive(message, params = {}) {
      params = {...params}      // hash_extract_self で破壊するため

      let toast_info = this.toast_info
      {
        const h = GX.hash_extract_self(params, "toast_key")
        if (h.toast_key) {
          toast_info = this.ToastInfo.fetch(h.toast_key)
        }
      }

      params = {
        ...this.ToastInfo.default_params,
        ...toast_info.default_params,
        ...params,
      }

      if (message) {
        if (this.development_p) {
          this.clog(message)
        }
        const h = GX.hash_extract_self(params, "toast", "talk", "duration_sec", "toast_message_fn", "toast_comma_delete")
        if (h.duration_sec) {
          GX.assert_kind_of_numeric(h.duration_sec)
          GX.assert(h.duration_sec < 1000)
          GX.assert(params.duration == null)
          params.duration = h.duration_sec * 1000
        }
        if (h.toast) {
          let str = message
          if (h.toast_message_fn) {
            str = h.toast_message_fn(str)
          }
          if (h.toast_comma_delete) {
            str = str.replace(/、/g, "")
          }
          this.$buefy.toast.open({...params, message: str})
        }
        if (h.talk) {
          return this.talk(message, params) // volume, rate, onend は talk 用オプション
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 未使用
    error_message_dialog(message, params = {}) {
      this.dialog_alert({
        message: message,
        title: "失敗",
        type: "is-danger",
        canCancel: [],
        ...params,
      })
    },

    bioshogi_error_modal_open(attributes) {
      const bioshogi_error = attributes.bioshogi_error
      if (bioshogi_error) {
        this.sfx_play("x")
        this.modal_card_open({
          props: { bioshogi_error: bioshogi_error },
          component: BioshogiErrorModal,
        })
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
        this.toast_primary(e.message, options)
      } else {
        throw new Error("must not happen")
      }
    },

    //////////////////////////////////////////////////////////////////////////////// modal

    // canCancel を ["outside", "escape"] にすると modal の instance を null に戻す処理を呼び忘れる事故が多発するため何も指定しないようにする
    // ["escape"] とすれば Esc キーで閉じれるのだけど keydown じゃなくて keyup に反応するので反応の遅さがめちゃくちゃ気持ち悪いのもある
    modal_card_open(params) {
      GX.assert_present(params.component)
      GX.assert_present(params.component.name)
      GX.assert_blank(params.canCancel)
      return this.$buefy.modal.open({
        width: "", // 名前は width だが実際には max-width に設定される
        customClass: `BasicModal ${params.component.name}`,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        scroll: "keep",
        animation: "",
        canCancel: [],          // 指定するな
        onCancel: () => this.sfx_click(),
        ...params,
      })
    },

    modal_card_open2(instance_name, params, callback = () => {}) {
      const instance = this[instance_name]
      if (!instance) {
        callback()
        GX.assert_kind_of_integer(this.g_modal_instance_count)
        this.g_modal_instance_count = this.g_modal_instance_count + 1
        this[instance_name] = this.modal_card_open(params)
      }
    },
    modal_card_close2(instance_name, callback = () => {}) {
      const instance = this[instance_name]
      if (instance) {
        callback()
        instance.close()
        this[instance_name] = null
        GX.assert_kind_of_integer(this.g_modal_instance_count)
        this.g_modal_instance_count = this.g_modal_instance_count - 1
        if (this.development_p) {
          GX.assert(this.g_modal_instance_count >= 0, "this.g_modal_instance_count >= 0")
        }
      }
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
    // buefy のドキュメントと実装に乖離があり width も customClass も効かない
    // その上、events: { close: () => { alert(1) }, も効かない
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
  computed: {
    ToastInfo() { return ToastInfo },
    toast_info() { return ToastInfo.lookup_or_first(this.g_toast_key) },
  },
}
