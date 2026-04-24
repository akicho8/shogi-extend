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
import QueryString from "query-string"

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
        ...this.current_role_group.to_url_hash,
        success_message: this.honpu_stage_info.kifu_copy_message,
      })
      if (success) {
        this.debug_alert("棋譜コピー完了")
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
      this.xhistory_puts("棋譜表示")
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
        this.xhistory_puts("棋譜ダウンロード")
      }
    },

    //////////////////////////////////////////////////////////////////////////////// 印刷

    // 現在のSFENを変換元としているのだけど本譜がある場合は本譜を作った時点の対局者名を渡している
    // この仕様は混乱のもとかもしれない
    // 本譜専用とすべきか？
    // かといってそうすると、本譜を作らずに印刷できなくてはまる場合もある
    async kifu_print_handle() {
      this.sfx_click()
      let params = {
        any_source: this.current_sfen,
        to_format: "kif",
      }

      // 本譜がある場合は対局者名を埋める
      if (this.honpu_master) {
        params = {
          ...params,
          title: this.honpu_master.title,
          ...this.honpu_master.current_role_group.to_url_hash,
        }
      }

      const e = await this.$axios.$post("/api/general/any_source_to.json", params)
      this.bioshogi_error_modal_open(e)
      if (e.body) {
        if (false) {
          this.$router.push({name: "adapter", query: {body: e.body, open: "print"}})
        } else {
          const url = QueryString.stringifyUrl({url: "/adapter", query: {body: e.body, open: "print"}})
          this.window_popup(url, {width: 1200, height: 800})
        }
      }
    },
  },
}
