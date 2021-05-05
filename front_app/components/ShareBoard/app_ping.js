import dayjs from "dayjs"

const PING_OK_SEC = 3  // N秒以内ならPINGを成功とみなす
const PONG_DELAY  = 0  // PONGするまでの秒数(デバッグ時には PING_OK_SEC 以上の値にする)

export const app_ping = {
  data() {
    return {
      ping_runner_id: null, // 実行中なら null 以外
      ping_success: false,  // 成功したら true
    }
  },

  beforeDestroy() {
    this.ping_callback_stop()
  },

  methods: {
    // メンバーをタップしたとき
    // --> ShareBoardMemberList.vue
    member_info_click_handle(e) {
      this.sound_play("click")
      if (this.ping_running_p()) {
        this.toast_warn("PING実行中...")
      } else {
        this.ping_command(e)
      }
    },

    //////////////////////////////////////////////////////////////////////////////// これだけあればいいけど失敗したかどうかわかりにくい

    ping_command(e) {
      this.ping_callback_set(e)
      this.ac_room_perform("ping_command", {
        to_user_name: e.from_user_name,
        to_user_code: e.from_user_code,
        ping_at: dayjs().valueOf(),
      }) // --> app/channels/share_board/room_channel.rb
    },
    ping_command_broadcasted(params) {
      if (params.to_user_code === this.user_code) {
        const now = dayjs().valueOf()
        this.delay_block(this.PONG_DELAY, () => this.pong_command(params))
        this.aclog("PING", `${params.from_user_name} → ${this.user_name} ${now - params.ping_at}ms`)
      }
    },
    pong_command(params) {
      this.ac_room_perform("pong_command", {
        to_user_name: params.from_user_name,
        to_user_code: params.from_user_code,
        ping_at: params.ping_at,
        pong_at: dayjs().valueOf(),
      }) // --> app/channels/share_board/room_channel.rb
    },
    pong_command_broadcasted(params) {
      if (params.to_user_code === this.user_code) {
        this.ping_done()
        const now = dayjs().valueOf()
        const gap = now - params.ping_at
        this.toast_ok(`${this.user_call_name(params.from_user_name)}の反応速度は${gap}ミリ秒です`, {toast_only: true})
        this.aclog("PONG", `${this.user_name} ← ${params.from_user_name} ${now - params.pong_at}ms`)
      }
    },

    //////////////////////////////////////////////////////////////////////////////// 一定時間待って失敗したら(反応がなければ)通知

    // PING実行中？
    ping_running_p() {
      return this.present_p(this.ping_runner_id)
    },

    // PING実行と同時に呼んどく
    ping_callback_set(e) {
      this.ping_success = false
      this.ping_callback_stop()
      this.ping_runner_id = this.delay_block(this.PING_OK_SEC, () => {
        if (!this.ping_success) {
          this.toast_ok(`${this.user_call_name(e.from_user_name)}の反応がありません`)
        }
        this.ping_callback_stop()
      })
    },

    // 途中でやめる
    ping_callback_stop() {
      if (this.ping_runner_id) {
        this.delay_stop(this.ping_runner_id)
        this.ping_runner_id = null
      }
    },

    // 成功
    ping_done() {
      this.ping_success = true
      this.ping_callback_stop()
    },
  },

  computed: {
    PING_OK_SEC() { return this.$route.PING_OK_SEC || PING_OK_SEC },
    PONG_DELAY()  { return this.$route.PONG_DELAY || PONG_DELAY   },
  },
}
