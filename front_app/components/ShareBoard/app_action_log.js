import _ from "lodash"
import dayjs from "dayjs"

const ACTION_LOG_MAX = 100
const ACTION_LOG_PUSH_TO = "top"

export const app_action_log = {
  data() {
    return {
      action_logs: [],
    }
  },
  methods: {
    //////////////////////////////////////////////////////////////////////////////// 共有版

    shared_al_add(e) {
      this.ac_room_perform("shared_al_add", e) // --> app/channels/share_board/room_channel.rb
    },
    shared_al_add_broadcasted(params) {
      // let exec = true
      if (this.received_from_self(params)) {
        // if (params.message_except_self) {
        //   exec = false
        // }
      } else {
      }
      this.al_add(params)
      // if (exec || this.development_p) {
      if (params.message) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が${params.message}`)
      }
      // }
    },

    ////////////////////////////////////////////////////////////////////////////////

    al_add(params) {
      params = {...params}

      // BCではなくローカルの場合もあるので復帰用に棋譜を埋める
      params.sfen ??= this.current_sfen
      params.turn_offset ??= this.current_turn_offset

      // その他
      params.from_user_name ??= this.user_name
      params.performed_at ??= this.time_current_ms()

      if (ACTION_LOG_PUSH_TO === "top") {
        this.action_logs.unshift(params)
        this.action_logs = _.take(this.action_logs, ACTION_LOG_MAX)
      } else {
        this.action_logs.push(params)
        this.action_logs = _.takeRight(this.action_logs, ACTION_LOG_MAX)
        this.al_scroll_to_bottom()
      }
    },
    al_add_test() {
      const i = this.base.action_logs.length
      this.al_add({
        lmi: {
          kif_without_from:    "☗00歩",
          next_turn_offset:    i,
          player_location_key: "black",
          yomiage:             "ななろくふ",
        },
        sfen: "position startpos",
        turn_offset: i,
        last_location_key: "white",
        from_user_name: "あいうえお",
        performed_at: this.time_current_ms(),
      })

      // this.al_add({
      //   label: "foo",
      //   sfen: "position startpos",
      //   turn_offset: 0,
      //   performed_at: this.time_current_ms(),
      // })

    },
    al_scroll_to_bottom() {
      const e = this.$refs.ShareBoardActionLog
      if (e) {
        this.scroll_to_bottom(e.$refs.scroll_block)
      }
    },

    action_log_jump(e) {
      if (false) {
        if (this.current_sfen === e.sfen && this.turn_offset === e.turn_offset) {
          this.toast_ok("同じ局面です")
          return
        }
      }

      this.__assert__('sfen' in e, "'sfen' in e")
      this.__assert__('turn_offset' in e, "'turn_offset' in e")

      this.current_sfen = e.sfen
      this.turn_offset = e.turn_offset
    },
  },
}
