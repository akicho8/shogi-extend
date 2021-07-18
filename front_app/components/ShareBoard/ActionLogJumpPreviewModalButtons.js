// ActionLogJumpPreviewModal 用の mixins
// ShareBoard.vue のスコープのものとメソッド名が重複しているので注意

import { DotSfen } from "@/components/models/dot_sfen.js"

export const ActionLogJumpPreviewModalButtons = {
  methods: {
    kifu_copy_handle() {
      this.sound_play("click")
      this.general_kifu_copy(this.action_log.sfen, {to_format: "kif", turn: this.new_turn_offset})
      this.base.shared_al_add_simple("棋譜コピー")
    },
    room_code_except_url_copy_handle() {
      this.sound_play("click")
      this.clipboard_copy({text: this.base.permalink_from_params(this.current_url_params)})
      this.base.shared_al_add_simple("棋譜リンクコピー")
    },
  },
  computed: {
    piyo_shogi_app_with_params_url() {
      return this.piyo_shogi_auto_url({
        sfen: this.action_log.sfen,
        turn: this.new_turn_offset,
        viewpoint: this.base.sp_viewpoint,
        game_name: this.base.current_title,
      })
    },
    kento_app_with_params_url() {
      return this.kento_full_url({
        sfen: this.action_log.sfen,
        turn: this.new_turn_offset,
        viewpoint: this.base.sp_viewpoint,
      })
    },
    current_url_params() {
      return this.base.url_params_clean({
        // 必須
        body: DotSfen.escape(this.action_log.sfen),
        // オプション
        turn: this.new_turn_offset,
        title:  this.base.current_title,
        abstract_viewpoint: this.base.abstract_viewpoint, // TODO: メインの盤ではなくプレビュー盤の視点を渡した方がよい
      })
    },
  },
}
