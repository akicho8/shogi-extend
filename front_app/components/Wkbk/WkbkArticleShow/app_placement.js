// 配置タブ関連

export const app_placement = {
  data() {
    return {
      sp_body:      null, // 配置の現在の状態
      sp_viewpoint: null, // 配置の視点
    }
  },

  methods: {
    // 配置で駒を動かしたときのフック。article.init_sfen は変更しないようにする
    edit_mode_snapshot_sfen(sfen) {
      this.sp_body = sfen
    },

    // 駒箱正規化
    piece_box_piece_counts_adjust() {
      this.$refs.WkbkArticleShowPlacement?.$refs.main_sp.sp_object().mediator.piece_box_piece_counts_adjust()
    },
  },
}
