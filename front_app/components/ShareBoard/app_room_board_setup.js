export const app_room_board_setup = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    // 盤面の情報を送ってほしい
    setup_info_request() {
      this.ac_room_perform("setup_info_request", {
      }) // --> app/channels/share_board/room_channel.rb
    },
    setup_info_request_broadcasted(params) {
      // this.tl_alert(`${this.user_call_name(params.from_user_name)}が入室しました`)
      if (this.development_p) {
        this.sound_play("pon")
      }
      this.clog(`${params.from_connection_id} が要求`)
      if (this.received_from_self(params)) {
        this.clog(`自分から自分へ`)
      } else {
        this.clog("参加者に盤の状態を教えてあげる")
        this.setup_info_send({
          to_connection_id: params.from_connection_id,
          to_user_name: params.from_user_name,
        })

        this.clog("参加者はこの部屋に誰がいるのかわかってないので自分がいることも教えてあげる")
        this.member_info_share()

        this.clog("参加者は対局時計があることも知らないので教えてあげる")
        this.clock_box_share()
      }
    },

    // 盤面の情報を送って欲しい人がいるので送ってあげる
    setup_info_send(params) {
      this.__assert__(params.to_connection_id != null, "params.to_connection_id != null")
      this.__assert__(params.to_user_name != null, "params.to_user_name != null")

      this.clog(`${params.to_user_name} に送る`)
      this.ac_room_perform("setup_info_send", {
        ...params,                  // 送り先 to_connection_id, to_user_name
        ////////////////////////////////////////////////////////////////////////////////
        title: this.current_title,  // タイトル
        ...this.current_sfen_attrs, // 盤の状態
        ...this.om_params,            // 順番設定
        ////////////////////////////////////////////////////////////////////////////////
      }) // --> app/channels/share_board/room_channel.rb
    },
    setup_info_send_broadcasted(params) {
      if (this.received_from_self(params)) {
        this.clog("自分から自分へ")
      } else {
        this.clog(`${params.from_user_name} が ${params.to_user_name} に ${params.sfen} を送信したものを ${this.user_name} が受信`)
        if (params.to_connection_id === this.connection_id) {
          this.clog("要求した情報を受信した")
          this.clog(`先輩度比較: 相手(${params.active_level}) > 自分(${this.active_level}) --> ${params.active_level > this.active_level}`)
          if (params.active_level > this.active_level) {
            this.ac_log("情報設定", `${params.from_user_name}の情報を利用 (${this.active_level} < ${params.active_level})`)
            this.tl_alert("最新の状態を共有してもらった")
            this.active_level = params.active_level
            this.setup_by_params(params)
          } else {
            this.clog("自分より新参の情報なので反映しない")
          }
        }
      }
    },
  },
}
