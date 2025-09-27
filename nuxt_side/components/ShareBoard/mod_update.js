const AUTO_RELOAD = false
const MESSAGE = "新しいプログラムがあるのでブラウザをリロードします"

export const mod_update = {
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
      if (new_api_version == null) {
        return
      }
      if (new_api_version === this.API_VERSION) {
        // this.tl_alert("VERSION OK")
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
      this.sb_talk(MESSAGE)
      this.sfx_stop_all()
      this.dialog_alert({
        message: MESSAGE,
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
