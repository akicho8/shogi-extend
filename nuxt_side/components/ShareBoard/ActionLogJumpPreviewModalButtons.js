// ActionLogJumpPreviewModal 用の mixins
// ShareBoard.vue のスコープのものとメソッド名が重複しているので注意

import { DotSfen } from "@/components/models/dot_sfen.js"
import { Location } from "shogi-player/components/models/location.js"

export const ActionLogJumpPreviewModalButtons = {
  methods: {
    // 棋譜コピー
    kifu_copy_handle() {
      this.sound_play_click()
      this.general_kifu_copy(this.action_log.sfen, {
        to_format: "kif",
        turn: this.new_turn,
        ...this.action_log.player_names_with_title,
      })
      this.base.shared_al_add_simple("棋譜コピー")
    },

    // 棋譜リンクコピー
    room_code_except_url_copy_handle() {
      this.sound_play_click()
      const success_message = "棋譜再生用のリンクをコピーしました"
      const url = this.base.permalink_from_params(this.current_url_params)
      this.clipboard_copy({text: url, success_message: success_message})
      this.base.shared_al_add_simple("棋譜リンクコピー")
    },

    // 指定の棋譜への直リンURL
    kifu_show_url(e) {
      this.__assert__("format_key" in e, '"format_key" in e')
      return this.base.permalink_for({
        format: e.format_key,
        body_encode: "auto",    // 文字コード自動判別
        image_viewpoint: this.sp_viewpoint, // abstract_viewpoint より image_viewpoint の方を優先する
      })
    },

    // 指定の棋譜を表示
    kifu_show_handle(e) {
      this.window_popup(this.kifu_show_url(e))
      this.base.shared_al_add_simple("棋譜表示")
    },

    // 指定の棋譜のダウンロードURL
    kifu_download_url(e) {
      return this.base.permalink_from_params({
        ...this.current_url_params,
        ...e.to_h_format_and_encode,
        disposition: "attachment",
      })
    },

    // 指定の棋譜をダウンロード
    kifu_download_handle(e) {
      if (typeof window !== 'undefined') {
        window.location.href = this.kifu_download_url(e)
        this.base.shared_al_add_simple("棋譜ダウンロード")
      }
    },

  },
  computed: {
    piyo_shogi_app_with_params_url() {
      return this.piyo_shogi_auto_url({
        sfen: this.action_log.sfen,
        turn: this.new_turn,
        viewpoint: this.sp_viewpoint,
        // ぴよ将棋はパラメータ名がかなり異なる
        game_name:  this.action_log.player_names_with_title.title,
        sente_name: this.action_log.player_names_with_title.black,
        gote_name:  this.action_log.player_names_with_title.white,
      })
    },
    kento_app_with_params_url() {
      return this.kento_full_url({
        sfen: this.action_log.sfen,
        turn: this.new_turn,
        viewpoint: this.sp_viewpoint,
      })
    },
    current_url_params() {
      return this.base.url_params_clean({
        // 必須
        body: DotSfen.escape(this.action_log.sfen),
        // オプション
        turn: this.new_turn,
        abstract_viewpoint: this.base.abstract_viewpoint, // メインの盤ではなくプレビュー盤の視点を渡した方がよい(↓追加)
        image_viewpoint: this.sp_viewpoint,               // abstract_viewpoint より image_viewpoint の方が優先される
        ...this.action_log.player_names_with_title,       // 面子情報
      })
    },
  },
}
