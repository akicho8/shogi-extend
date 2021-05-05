import dayjs from "dayjs"

const PING_FAILED_DELAY = 3 // PINGを失敗とみなす秒数
const PONG_DELAY        = 0 // PONGするまでの秒数(デバッグ時には PING_FAILED_DELAY 以上の値にする)

export const app_ping = {
  data() {
    return {
      ping_user_codes: {},
    }
  },

  methods: {
    // --> ShareBoardMemberList.vue
    member_info_click_handle(e) {
      this.sound_play("click")
      if (this.ping_process_p(e)) {
        this.toast_warn("PING実行中...")
      } else {
        this.ping_command(e)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    ping_command(member_info) {
      this.ping_start_hook(member_info)
      this.ac_room_perform("ping_command", {
        to_user_name: member_info.from_user_name,
        to_user_code: member_info.from_user_code,
        ping_at: dayjs().valueOf(),
      }) // --> app/channels/share_board/room_channel.rb
    },
    ping_command_broadcasted(params) {
      if (params.to_user_code === this.user_code) {
        const now = dayjs().valueOf()
        this.delay_block(this.PONG_DELAY, () => this.pong_command(params))
        this.pong_command(params)
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
        this.ping_success(params)
        const now = dayjs().valueOf()
        const gap = now - params.ping_at
        this.toast_ok(`${this.user_call_name(params.from_user_name)}の反応速度は${gap}ミリ秒です`, {toast_only: true})
        this.aclog("PONG", `${this.user_name} ← ${params.from_user_name} ${now - params.pong_at}ms`)
      }
    },

    //////////////////////////////////////////////////////////////////////////////// 一定時間待って反応がなければ通知

    // 処理中か？ ややこしくなるので排他制御すること
    ping_process_p(e) {
      return (this.ping_user_codes[e.from_user_code] || 0) >= 1
    },
    // 開始
    ping_start_hook(e) {
      if (this.ping_user_codes[e.from_user_code] == null) {
        this.ping_user_codes[e.from_user_code] = 0
      }
      this.ping_user_codes[e.from_user_code] += 1
      this.delay_block(this.PING_FAILED_DELAY, () => {
        if (this.ping_user_codes) {
          if (this.ping_user_codes[e.from_user_code] >= 1) {
            this.ping_failed(e)
          }
        }
      })
    },
    // 失敗
    ping_failed(e) {
      this.toast_ok(`${this.user_call_name(e.from_user_name)}の反応がありません`)
    },
    // 成功
    ping_success(e) {
      this.ping_user_codes[e.from_user_code] = 0
    },
  },

  computed: {
    PING_FAILED_DELAY() { return this.$route.PING_FAILED_DELAY || PING_FAILED_DELAY },
    PONG_DELAY()        { return this.$route.PONG_DELAY || PONG_DELAY },
  },
}
