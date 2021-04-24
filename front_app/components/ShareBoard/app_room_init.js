import { IntervalRunner } from '@/components/models/interval_runner.js'

export const app_room_init = {
  data() {
    return {
      revision_increment_timer: new IntervalRunner(this.revision_increment_timer_callback, {early: false, interval: 1.0}),
    }
  },
  created() {
    this.$revision = 0
  },
  beforeDestroy() {
    if (this.revision_increment_timer) {
      this.revision_increment_timer.stop()
    }
  },
  methods: {
    revision_increment_timer_callback() {
      this.$revision += 1
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 盤面の情報を送ってほしい
    setup_info_request() {
      this.ac_room_perform("setup_info_request", {
      }) // --> app/channels/share_board/room_channel.rb
    },
    setup_info_request_broadcasted(params) {
      this.debug_alert(`${this.user_call_name(params.from_user_name)}が入室しました`)
      this.sound_play("pon")
      this.clog(`${params.from_user_code} が要求`)
      if (params.from_user_code === this.user_code) {
        this.clog(`自分から自分へ`)
      } else {
        this.clog("参加者に盤の状態を教えてあげる")
        this.setup_info_send(params.from_user_code)

        this.clog("参加者はこの部屋に誰がいるのかわかってないので自分がいることも教えてあげる")
        this.member_info_share()

        this.clog("参加者は対局時計があることも知らないので教えてあげる")
        this.chess_clock_share("")
      }
    },

    // 盤面の情報を送って欲しい人がいるので送ってあげる
    setup_info_send(to_user) {
      this.clog(`${to_user} に送る`)
      this.ac_room_perform("setup_info_send", {
        to_user: to_user,           // 送り先
        ////////////////////////////////////////////////////////////////////////////////
        title: this.current_title,  // タイトル
        ...this.current_sfen_attrs, // 盤の状態
        ...this.om_vars,      // 順番設定
        ////////////////////////////////////////////////////////////////////////////////
      }) // --> app/channels/share_board/room_channel.rb
    },
    setup_info_send_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        this.clog(`自分から自分へ`)
      } else {
        this.clog(`${params.from_user_code} が ${params.to_user} に ${params.sfen} を送信したものを ${this.user_code} が受信`)
        if (params.to_user === this.user_code) {
          this.clog(`リクエストした情報を送ってもらった`)
          this.clog(`リビジョン比較: 相手(${params.revision}) > 自分(${this.$revision}) --> ${params.revision > this.$revision}`)
          if (params.revision > this.$revision) {
            this.clog(`自分より古参の情報なので反映する`)
            this.debug_alert(`${this.user_call_name(params.from_user_name)}から最新の状態を共有してもらいました`)
            this.$revision = params.revision
            this.setup_by_params(params)
          } else {
            this.clog(`自分より新参の情報なので反映しない`)
          }
        }
      }
    },
  },
}
