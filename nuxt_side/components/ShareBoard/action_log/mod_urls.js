// ActionLogModal 用の mixins
// Sb.vue のスコープのものとメソッド名が重複しているので注意

import { DotSfen } from "@/components/models/dot_sfen.js"
import { SafeSfen } from "@/components/models/safe_sfen.js"
import { Location } from "shogi-player/components/models/location.js"
import { Gs } from "@/components/models/gs.js"

export const mod_urls = {
  methods: {
    // 棋譜コピー
    kifu_copy_handle() {
      this.sfx_click()
      this.general_kifu_copy(this.new_sfen, {
        to_format: "kif",
        turn: this.new_turn,
        ...this.action_log.player_names_with_title,
      })
      this.SB.al_share_puts("棋譜コピー")
    },

    // 棋譜URLコピー
    current_url_copy_handle() {
      this.sfx_click()
      this.clipboard_copy(this.current_url, {success_message: "棋譜再生用のURLをコピーしました"})
      this.SB.al_share_puts("棋譜URLコピー")
    },

    // 指定の棋譜への直リンURL
    kifu_show_url(e) {
      Gs.assert("format_key" in e, '"format_key" in e')
      return this.url_merge({
        format: e.format_key,
        body_encode: "auto",    // 文字コード自動判別
      })
    },

    // 指定の棋譜を表示
    kifu_show_handle(e) {
      this.sfx_click()
      this.window_popup(this.kifu_show_url(e))
      this.SB.al_share_puts("棋譜表示")
    },

    // 指定の棋譜のダウンロードURL
    kifu_download_url(e) {
      return this.url_merge({...e.to_h_format_and_encode, disposition: "attachment"})
    },

    // 指定の棋譜をダウンロード
    kifu_download_handle(e) {
      if (typeof window !== 'undefined') {
        this.sfx_click()
        window.location.href = this.kifu_download_url(e)
        this.SB.al_share_puts("棋譜ダウンロード")
      }
    },

    url_merge(params = {}) {
      return this.SB.url_for({...this.current_url_params, ...params})
    },
  },
  computed: {
    new_sfen()         { return this.action_log.sfen },
    current_url()      { return this.url_merge({}) },
    current_kif_url()  { return this.url_merge({format: "kif"}) },
    json_debug_url()   { return this.url_merge({format: "json"}) },
    twitter_card_url() { return this.url_merge({format: "png"}) },

    current_url_params() {
      const params = {
        xbody: SafeSfen.encode(this.new_sfen),      // プレビュー盤のSFEN
        turn: this.new_turn,                        // プレビュー盤の手数
        viewpoint: this.viewpoint,                  // メインの盤よりプレビュー盤の視点を優先させたいため
        ...this.SB.url_share_params,              // 共有するパラメータ
        ...this.action_log.player_names_with_title, // 面子情報
      }
      return this.SB.pc_url_params_clean(params)
    },

    current_kifu_vo() {
      return this.$KifuVo.create({
        kif_url: this.current_kif_url,
        sfen: this.new_sfen,
        turn: this.new_turn,
        viewpoint: this.viewpoint,
      })
    },
  },
}
