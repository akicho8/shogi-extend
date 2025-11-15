export const mod_share_dto = {
  methods: {
    // 他者からの受信を自分に反映する
    share_dto_receive(params) {
      this.tl_add("全共有", "他者からの受信を自分に反映する", params)
      this.room_name_share_dto_receive(params.room_name_share_dto)
      this.xprofile_share_dto_receive(params.xprofile_share_dto)
      this.sfen_share_dto_receive(params.sfen_share_dto)
      this.order_share_dto_receive(params.order_share_dto)
      this.clock_share_dto_receive(params.clock_share_dto)
      this.honpu_share_dto_receive(params.honpu_share_dto)
    }
  },
  computed: {
    // 他者に共有するデータを準備する
    share_dto_all() {
      return {
        room_name_share_dto: this.room_name_share_dto, // タイトル
        xprofile_share_dto: this.xprofile_share_dto, // スコア情報
        sfen_share_dto:  this.sfen_share_dto,  // 棋譜と現在の局面(手数)
        order_share_dto: this.order_share_dto, // 順番設定
        clock_share_dto: this.clock_share_dto, // 対局時計
        honpu_share_dto: this.honpu_share_dto, // 本譜
      }
    },
  },
}
