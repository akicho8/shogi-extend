const AUTO_RELOAD = false
const MESSAGE = "新しいプログラムがあるのでブラウザをリロードします"

export const app_update = {
  data() {
    return {
      app_update_now: false,
    }
  },
  methods: {
    api_version_valid(new_api_version) {
      if (this.app_update_now) {
        return
      }
      if (new_api_version === this.API_VERSION) {
        // this.debug_alert("VERSION OK")
      } else {
        this.app_update_now = true
        if (AUTO_RELOAD) {
          this.toast_ok(MESSAGE, {onend: () => this.force_reload()})
        } else {
          this.reload_modal_handle()
        }
      }
    },
    reload_modal_handle() {
      this.talk(MESSAGE)
      this.talk_stop()
      this.$buefy.dialog.alert({
        message: MESSAGE,
        confirmText: "OK",
        onConfirm: () => this.force_reload(),
      })
    },
    force_reload() {
      window.location.reload()
    },
  },
  computed: {
    API_VERSION() { return parseFloat(this.$route.query.API_VERSION || this.record.API_VERSION) },
  },
}
