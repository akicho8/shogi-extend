export const app_chore = {
  methods: {
    dl_click_handle() {
      this.sidebar_close()
      this.delay_block(1, () => this.toast_ok(`たぶんダウンロードしました`))
    },
  },
}
