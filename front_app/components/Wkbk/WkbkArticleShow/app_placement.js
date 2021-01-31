export const app_placement = {
  data() {
    return {
      // sp_body: null,
    }
  },

  methods: {
    // 駒箱正規化
    piece_box_piece_couns_adjust() {
      this.$refs.WkbkArticleShowPlacement?.$refs.main_sp.sp_object().mediator.piece_box_piece_couns_adjust()
    },
  },
}
