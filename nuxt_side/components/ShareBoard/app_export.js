export const app_export = {
  methods: {
    //////////////////////////////////////////////////////////////////////////////// clipboard

    // 現在のURLをコピー
    current_url_copy_handle() {
      this.sound_play_click()
      this.clipboard_copy({text: this.current_url})
    },

    // 指定の棋譜をコピー
    kifu_copy_handle(e) {
      this.__assert__("format_key" in e, '"format_key" in e')
      this.sidebar_p = false
      this.sound_play_click()
      this.general_kifu_copy(this.current_sfen, {to_format: e.format_key, turn: this.current_turn})
      this.shared_al_add_simple("棋譜コピー")
    },

    //////////////////////////////////////////////////////////////////////////////// show

    // 指定の棋譜への直リンURL
    kifu_show_url(e) {
      this.__assert__("format_key" in e, '"format_key" in e')
      return this.permalink_for({
        format: e.format_key,
        image_viewpoint: this.sp_viewpoint, // abstract_viewpoint より image_viewpoint の方を優先する
      })
    },

    // 指定の棋譜を表示
    kifu_show_handle(e) {
      this.window_popup(this.kifu_show_url(e))
      this.shared_al_add_simple("棋譜表示")
    },

    //////////////////////////////////////////////////////////////////////////////// download

    // 指定の棋譜のダウンロードURL
    kifu_download_url(e) {
      this.__assert__("format_key" in e, '"format_key" in e')
      return this.permalink_for({
        format: e.format_key,
        body_encode: e.body_encode,
        image_viewpoint: this.sp_viewpoint, // abstract_viewpoint より image_viewpoint の方が優先される
        disposition: "attachment",
      })
    },

    // 指定の棋譜をダウンロード
    kifu_download_handle(e) {
      if (typeof window !== 'undefined') {
        window.location.href = this.kifu_download_url(e)
        this.shared_al_add_simple("棋譜ダウンロード")
      }
    },
  },
}
