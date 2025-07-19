// ▼必要なメソッド
// |-------------------------|
// | current_turn            |
// | kifu_copy_handle(e)     |
// | kifu_show_handle(e)     |
// | kifu_show_url(e)        |
// | kifu_download_handle(e) |
// | kifu_download_url(e)    |
// |-------------------------|
// ../../ShareBoard/mod_export.js とメソッドを合わせる

import _ from "lodash"
import { FormatTypeInfo } from "@/components/models/format_type_info.js"
import QueryString from "query-string"

export const mod_export = {
  methods: {
    async kifu_copy_handle(e, params = {}) {
      const url = this.kifu_show_url(e, params)
      const retval = await this.kif_clipboard_copy_from_url(url)
      if (retval) {
        this.sidebar_close()
      }
    },

    kifu_show_url(e, params = {}) {
      return QueryString.stringifyUrl({
        url: this.$config.MY_SITE_URL + this.record.show_path + "." + e.format_key,
        query: {
          ...params,
          turn: this.current_turn,
        },
      })
    },

    // 指定の棋譜を表示
    kifu_show_handle(e) {
      this.window_popup(this.kifu_show_url(e))
    },

    //////////////////////////////////////////////////////////////////////////////// download

    kifu_download_url(e) {
      return this.kifu_show_url(e, {
        ...e.to_h_format_and_encode,
        disposition: "attachment",
      })
    },

    kifu_download_handle(e) {
      if (typeof window !== 'undefined') {
        this.sidebar_close()
        window.location.href = this.kifu_download_url(e)
        this.$gs.delay_block(1, () => this.toast_ok(`たぶんダウンロードしました`))
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    image_dl_modal_handle() {
      this.sidebar_close()
      this.toast_ok("共有将棋盤に転送して画像を生成します")
      const params = {
        ...this.share_board_query,
        autoexec: "image_dl_modal_handle",
      }
      this.$router.push({name: "share-board", query: params})
    },
  },
}
