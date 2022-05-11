// 履歴
// タップ局面変更

const ACTION_LOG_MAX        = 200   // 履歴の最大長
const ACTION_LOG_PUSH_TO    = "top" // 追加位置
const SAME_SFEN_THEN_RETURN = false // 同じ局面なら何もしない？

import _ from "lodash"
import dayjs from "dayjs"

export const app_action_log = {
  data() {
    return {
      action_logs: [],
    }
  },
  methods: {
    //////////////////////////////////////////////////////////////////////////////// 共有版

    // 発動する側の棋譜を持っている
    shared_al_add_simple(label) {
      this.shared_al_add({
        label: label,
        message: `${label}しました`,
        // message_except_self: true,
        sfen: this.current_sfen,
        turn: this.current_turn,
      })
    },
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
      this.ac_log("履歴追加", `「${params.label}」を受信`)
      // }
    },

    ////////////////////////////////////////////////////////////////////////////////

    al_add(params) {
      params = {...params}

      // BCではなくローカルの場合もあるので復帰用に棋譜を埋める
      params.sfen ??= this.current_sfen
      params.turn ??= this.current_turn

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
        turn: i,
        // last_location_key: "white",
        from_user_name: "あいうえお",
        performed_at: this.time_current_ms(),
      })

      // this.al_add({
      //   label: "foo",
      //   sfen: "position startpos",
      //   turn: 0,
      //   performed_at: this.time_current_ms(),
      // })

    },
    al_scroll_to_bottom() {
      const e = this.$refs.ShareBoardActionLog
      if (e) {
        this.scroll_to_bottom(e.$refs.SideColumnScroll)
      }
    },

    action_log_jump(e) {
      this.__assert__('sfen' in e, "'sfen' in e")
      this.__assert__('turn' in e, "'turn' in e")

      if (SAME_SFEN_THEN_RETURN) {
        if (this.current_sfen === e.sfen && this.current_turn === e.turn) {
          this.toast_ok("同じ局面です")
          return
        }
      }

      this.current_sfen = e.sfen
      this.current_turn = e.turn

      if (this.ac_room) {
        this.$nextTick(() => this.quick_sync(`${this.user_call_name(this.user_name)}が戻した局面を転送しました`))
      }
    },
  },
}
