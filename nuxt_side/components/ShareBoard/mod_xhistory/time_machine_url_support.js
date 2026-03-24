// TimeMachineModal 用の mixins
// Sb.vue のスコープのものとメソッド名が重複しているので注意

import { DotSfen } from "@/components/models/dot_sfen.js"
import { SafeSfen } from "@/components/models/safe_sfen.js"
import { GX } from "@/components/models/gx.js"

export const time_machine_url_support = {
  methods: {
    // 棋譜コピー
    kifu_copy_handle() {
      this.sfx_click()
      this.general_kifu_copy(this.master.sfen, {
        to_format: "kif",
        turn: this.master.turn,
        title: this.xhistory_record.title,
        ...this.xhistory_record.role_group.to_url_hash,
      })
      this.SB.xhistory_puts("棋譜コピー")
    },

    // 棋譜URLコピー
    current_long_url_copy_handle() {
      this.sfx_click()
      this.clipboard_copy(this.current_url, {success_message: "棋譜再生用のURLをコピーしました"})
      this.SB.xhistory_puts("棋譜URLコピー")
    },

    // 指定の棋譜への直リンURL
    kifu_show_url(e) {
      GX.assert("format_key" in e, '"format_key" in e')
      return this.url_merge({
        format: e.format_key,
        body_encode: "auto",    // 文字コード自動判別
      })
    },

    // 指定の棋譜を表示
    kifu_show_handle(e) {
      this.sfx_click()
      this.window_popup(this.kifu_show_url(e))
      this.SB.xhistory_puts("棋譜表示")
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
        this.SB.xhistory_puts("棋譜ダウンロード")
      }
    },

    url_merge(params = {}) {
      return this.SB.url_for({...this.current_url_params, ...params})
    },
  },
  computed: {
    current_url()      { return this.url_merge({}) },
    current_kif_url()  { return this.url_merge({format: "kif"}) },
    json_debug_url()   { return this.url_merge({format: "json"}) },
    twitter_card_url() { return this.url_merge({format: "png"}) },

    current_url_params() {
      const params = {
        xbody: SafeSfen.encode(this.master.sfen),      // プレビュー盤のSFEN
        turn: this.master.turn,                        // プレビュー盤の手数
        viewpoint: this.mut_viewpoint,                  // メインの盤よりプレビュー盤の視点を優先させたいため
        ...this.SB.url_share_params,              // 共有するパラメータ
        title: this.xhistory_record.title,
        ...this.xhistory_record.role_group.to_url_hash, // 面子情報
      }
      return this.SB.pc_url_params_clean(params)
    },

    current_kifu_vo() {
      return this.$KifuVo.create({
        kif_url: this.current_kif_url,
        sfen: this.master.sfen,
        turn: this.master.turn,
        viewpoint: this.mut_viewpoint,
      })
    },
  },
}
