export const mod_share_data = {
  methods: {
    // 他者からの受信を自分に反映する
    share_data_receive(params) {
      this.title_share_data_receive(params.title_share_data)
      this.medal_share_data_receive(params.medal_share_data)
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
        medal_share_data: this.medal_share_data, // スコア情報
        sfen_share_data:  this.sfen_share_data,  // 棋譜と現在の局面(手数)
        order_share_data: this.order_share_data, // 順番設定
        clock_share_data: this.clock_share_data, // 対局時計
        honpu_share_data: this.honpu_share_data, // 本譜
      }
    },
  },
}
