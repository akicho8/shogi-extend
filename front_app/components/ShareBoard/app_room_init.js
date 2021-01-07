export const app_room_init = {
  data() {
    return {
      idol_timer_id: null,
    }
  },
  beforeDestroy() {
    this.idol_timer_stop()
  },
  methods: {
    idol_timer_start() {
      this.idol_timer_stop()
      this.$revision = 0
      this.idol_timer_id = setInterval(this.idol_timer_process, 1000)
    },

    idol_timer_stop() {
      if (this.idol_timer_id) {
        clearInterval(this.idol_timer_id)
        this.idol_timer_id = null
      }
    },

    idol_timer_process() {
      this.$revision += 1
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 盤面の情報を送ってほしい
    board_info_request() {
      this.ac_room_perform("board_info_request", {
      }) // --> app/channels/share_board/room_channel.rb
    },
    board_info_request_broadcasted(params) {
      this.clog(`${params.from_user_code} が欲しいと言っている`)
      if (params.from_user_code === this.user_code) {
        this.clog(`自分から自分へ`)
      } else {
        this.board_info_send(params.from_user_code)
      }
    },

    // 盤面の情報を送って欲しい人がいるので送ってあげる
    board_info_send(to_user) {
      this.clog(`${to_user} に送る`)
      this.ac_room_perform("board_info_send", {
        to_user: to_user,         // 送り先
        revision: this.$revision,
        title: this.current_title,
        ...this.current_sfen_attrs,
      }) // --> app/channels/share_board/room_channel.rb
    },
    board_info_send_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        this.clog(`自分から自分へ`)
      } else {
        this.clog(`${params.from_user_code} が ${params.to_user} に ${params.sfen} を送信したものを ${this.user_code} が受信`)
        if (params.to_user === this.user_code) {
          this.clog(`リクエストした情報を送ってもらった`)
          this.clog(`リビジョン比較: 相手(${params.revision}) > 自分(${this.$revision}) --> ${params.revision > this.$revision}`)
          if (params.revision > this.$revision) {
            this.clog(`自分より古参の情報なので反映する`)
            this.toast_ok(`${params.from_user_name}さんから最新の状態を共有してもらいました`)
            this.$revision = params.revision
            this.attributes_set(params)
          } else {
            this.clog(`自分より新参の情報なので反映しない`)
          }
        }
      }
    },
  },
}
