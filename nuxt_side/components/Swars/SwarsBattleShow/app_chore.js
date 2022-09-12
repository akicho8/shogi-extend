export const app_chore = {
  methods: {
    // kifu_download_handle() {
    //   this.sidebar_close()
    //   this.delay_block(1, () => this.toast_ok(`たぶんダウンロードしました`))
    // },
    official_show_handle() {
      this.sound_play_click()
      this.window_popup_if_desktop(this.official_show_url, {width: 400, height: 700})
    },
  },
}
