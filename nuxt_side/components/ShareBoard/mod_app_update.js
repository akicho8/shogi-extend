export const mod_app_update = {
  data() {
    return {
      app_update_now: false,
    }
  },
  methods: {
    async api_version_validate(new_api_version) {
      if (this.app_update_now) {
        return
      }
      if (new_api_version == null) {
        return
      }
      if (new_api_version !== this.API_VERSION) {
        this.app_force_reload_notify_modal_open()
      }
    },
    app_force_reload_notify_modal_open() {
      const message = "新しいプログラムがあるのでブラウザをリロードして更新します (対局中だった場合の対局は無効になります)"
      this.app_update_now = true
      this.sfx_stop_all()
      this.sb_talk(message)
      this.dialog_alert({
        title: "アプリ更新",
        confirmText: "わかった",
        message: message,
        onConfirm: () => this.app_force_reload(),
      })
    },
    app_force_reload() {
      window.location.reload()
    },
  },
  computed: {
    API_VERSION() { return this.param_to_i("API_VERSION", this.record.API_VERSION) },
  },
}
