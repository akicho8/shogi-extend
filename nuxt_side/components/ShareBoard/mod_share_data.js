export const mod_share_data = {
  methods: {
    // 他者からの受信を自分に反映する
    share_data_receive(params) {
      this.tl_add("全共有", "他者からの受信を自分に反映する", params)
      this.title_share_data_receive(params.title_share_data)
      this.xbadge_dist_hash_receive(params.xbadge_dist_hash)
      this.sfen_share_data_receive(params.sfen_share_data)
      this.order_share_data_receive(params.order_share_data)
      this.clock_share_data_receive(params.clock_share_data)
      this.honpu_share_data_receive(params.honpu_share_data)
    }
  },
  computed: {
    // 他者に共有するデータを準備する
    share_data_all() {
      return {
        title_share_data: this.title_share_data, // タイトル
        xbadge_dist_hash: this.xbadge_dist_hash, // スコア情報
        sfen_share_data:  this.sfen_share_data,  // 棋譜と現在の局面(手数)
        order_share_data: this.order_share_data, // 順番設定
        clock_share_data: this.clock_share_data, // 対局時計
        honpu_share_data: this.honpu_share_data, // 本譜
      }
    },
  },
}
