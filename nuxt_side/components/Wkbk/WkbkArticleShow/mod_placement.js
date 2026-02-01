// 配置タブ関連

export const mod_placement = {
  data() {
    return {
      sp_body:      null, // 配置の現在の状態
      viewpoint: null, // 配置の視点
    }
  },

  methods: {
    // 配置で駒を動かしたときのフック。article.init_sfen は変更しないようにする
    ev_edit_mode_short_sfen_change(sfen) {
      this.sp_body = sfen
    },

    // 駒箱正規化
    piece_box_piece_counts_adjust$() {
      this.$refs.WkbkArticleShowPlacement?.$refs.main_sp.sp_object().xcontainer.piece_box_piece_counts_adjust$()
    },
  },
}
