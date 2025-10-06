export const mod_share_data = {
  methods: {
    // 他者からの受信を自分に反映する
    share_data_receive(params) {
      this.tl_add("全共有", "他者からの受信を自分に反映する", params)
      this.room_name_share_data_receive(params.room_name_share_data)
      this.xprofile_share_data_receive(params.xprofile_share_data)
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
        room_name_share_data: this.room_name_share_data, // タイトル
        xprofile_share_data: this.xprofile_share_data, // スコア情報
        sfen_share_data:  this.sfen_share_data,  // 棋譜と現在の局面(手数)
        order_share_data: this.order_share_data, // 順番設定
        clock_share_data: this.clock_share_data, // 対局時計
        honpu_share_data: this.honpu_share_data, // 本譜
      }
    },
  },
}
