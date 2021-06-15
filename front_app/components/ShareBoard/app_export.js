export const app_export = {
  methods: {
    //////////////////////////////////////////////////////////////////////////////// clipboard

    // 現在のURLをコピー
    current_url_copy_handle() {
      this.sound_play("click")
      this.clipboard_copy({text: this.current_url})
    },

    // 指定の棋譜をコピー
    kifu_copy_handle(e) {
      this.sidebar_p = false
      this.sound_play("click")
      this.general_kifu_copy(this.current_sfen, {to_format: e.format_key, turn: this.turn_offset})

      this.shared_al_add({
        label: "棋譜コピー",
        message: "棋譜コピーしました",
        // message_except_self: true,
        sfen: this.current_sfen,
        turn_offset: this.turn_offset,
      })
    },

    //////////////////////////////////////////////////////////////////////////////// show

    // 指定の棋譜への直リンURL
    kifu_show_url(e) {
      return this.permalink_for({
        format: e.format_key,
        image_viewpoint: this.sp_viewpoint, // abstract_viewpoint より image_viewpoint の方を優先する
      })
    },

    // 指定の棋譜を表示
    kifu_show_handle(e) {
      this.window_popup(this.kifu_show_url(e))
    },

    //////////////////////////////////////////////////////////////////////////////// download

    // 指定の棋譜のダウンロードURL
    kifu_download_url(e) {
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
      }
    },
  },
}
