export const mod_app_update = {
  data() {
    return {
      app_update_now: false,
    }
  },
  methods: {
    api_version_validate(server_side_api_version) {
      if (this.app_update_now) {
        return
      }
      if (server_side_api_version !== this.CLIENT_SIDE_API_VERSION) {
        this.app_force_reload_notify_modal_open()
      }
    },
    app_force_reload_notify_modal_open() {
      this.app_update_now = true
      this.dialog_alert({
        title: "アプリ更新",
        confirmText: "わかった",
        message: [
          `<div class="content">`,
          /**/ `<p>新しいプログラムがあるのでブラウザをリロードして更新します</p>`,
          /**/ `<p>対局中だった場合の対局は無効になります</p>`,
          `</div>`,
        ].join(""),
        onConfirm: () => this.app_force_reload(),
      })
    },
    app_force_reload() {
      window.location.reload()
    },
  },
  computed: {
    CLIENT_SIDE_API_VERSION() { return this.param_to_i("CLIENT_SIDE_API_VERSION", this.record.CLIENT_SIDE_API_VERSION) },
  },
}
