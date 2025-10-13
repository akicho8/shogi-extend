// ▼必要なメソッド
// |-------------------------|
// | current_turn            |
// | kifu_copy_handle(e)     |
// | kifu_show_handle(e)     |
// | kifu_show_url(e)        |
// | kifu_download_handle(e) |
// | kifu_download_url(e)    |
// |-------------------------|
// ../Swars/SwarsBattleShow/mod_export.js とメソッドを合わせる

import _ from "lodash"
import { GX } from "@/components/models/gx.js"

export const mod_export = {
  methods: {
    //////////////////////////////////////////////////////////////////////////////// clipboard

    // 指定の棋譜をコピー
    async kifu_copy_handle(e) {
      this.sfx_click()
      e = this.FormatTypeInfo.fetch(e)
      const success = await this.general_kifu_copy(this.current_sfen, {
        to_format: e.format_key,
        turn: this.current_turn,
        title: this.current_title,
        ...this.player_names,
      })
      if (success) {
        this.sidebar_p = false
      }
    },

    //////////////////////////////////////////////////////////////////////////////// show

    // 指定の棋譜への直リンURL
    kifu_show_url(e) {
      e = this.FormatTypeInfo.fetch(e)
      return this.url_merge({
        format: e.format_key,
        body_encode: "auto",    // 文字コード自動判別
      })
    },

    // 指定の棋譜を表示
    kifu_show_handle(e) {
      this.window_popup(this.kifu_show_url(e))
      this.al_share_puts("棋譜表示")
    },

    //////////////////////////////////////////////////////////////////////////////// download

    // 指定の棋譜のダウンロードURL
    kifu_download_url(e) {
      GX.assert("format_key" in e, '"format_key" in e')
      return this.url_merge({
        ...e.to_h_format_and_encode,
        disposition: "attachment",
      })
    },

    // 指定の棋譜をダウンロード
    kifu_download_handle(e) {
      if (typeof window !== 'undefined') {
        window.location.href = this.kifu_download_url(e)
        this.al_share_puts("棋譜ダウンロード")
      }
    },
  },
}
