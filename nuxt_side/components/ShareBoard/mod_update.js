const AUTO_RELOAD = false
const MESSAGE = "新しいプログラムがあるのでブラウザをリロードします"

export const mod_update = {
  data() {
    return {
      app_update_now: false,
    }
  },
  methods: {
    async api_version_valid(new_api_version) {
      if (this.app_update_now) {
        return
      }
      if (new_api_version == null) {
        return
      }
      if (new_api_version !== this.API_VERSION) {
        this.app_update_now = true
        if (AUTO_RELOAD) {
          await this.toast_primary(MESSAGE)
          this.force_reload()
        } else {
          this.reload_modal_handle()
        }
      }
    },
    reload_modal_handle() {
      this.sfx_stop_all()
      this.sb_talk(MESSAGE)
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
    API_VERSION() { return this.param_to_i("API_VERSION", this.record.API_VERSION) },
  },
}
