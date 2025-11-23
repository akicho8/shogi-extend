// 履歴
// タップ局面変更

const AL_RECORDS_MAX    = 200   // 履歴の最大長
const AL_SAME_SFEN_SKIP = false // 同じ局面なら何もしない？
const AL_TURN_ONLY_REVERT = true // 過去の履歴なら手数だけ戻す？

import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"
import ActionLogModal from "./ActionLogModal.vue"
import { ActionLogRecord } from "./action_log_record.js"

export const mod_action_log = {
  data() {
    return {
      action_logs: [],
    }
  },
  methods: {
    al_create(params = {}) {
      params = {...params}

      // BCではなくローカルの場合もあるので復帰用に棋譜を埋める
      params.sfen ??= this.current_sfen
      params.turn ??= this.current_turn
      params.viewpoint ??= this.viewpoint

      // その他
      params.from_user_name ??= this.user_name
      params.performed_at ??= this.$time.current_ms()

      // KIF に埋めたいものも合わせて保持しておく
      params.player_names_with_title ??= this.player_names_with_title

      return ActionLogRecord.create(params)
    },

    al_add(params) {
      const action_log_record = this.al_create(params)
      this.action_logs = _.take([action_log_record, ...this.action_logs], AL_RECORDS_MAX)
    },

    al_test() {
      const i = this.action_logs.length
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
        performed_at: this.$time.current_ms(),
      })
    },
    al_scroll_to_bottom() {
      const e = this.$refs.SbActionLog
      if (e) {
        this.$nextTick(() => this.scroll_to_bottom(e.$refs.SideColumnScroll))
      }
    },

    // 「この局面に移動しますか？」のダイアログ発動
    al_click_handle(action_log) {
      this.sfx_click()
      this.modal_card_open({
        component: ActionLogModal,
        props: {
          action_log: action_log,
        },
      })
    },

    // 局面を復元する
    al_restore(action_log) {
      GX.assert('sfen' in action_log, "'sfen' in action_log")
      GX.assert('turn' in action_log, "'turn' in action_log")

      if (AL_SAME_SFEN_SKIP) {
        if (this.current_sfen === action_log.sfen && this.current_turn === action_log.turn) {
          this.toast_primary("同じ局面です")
          return
        }
      }

      let message = null
      if (AL_TURN_ONLY_REVERT) {
        if (this.current_sfen.startsWith(action_log.sfen)) {
          message = `${action_log.turn}手目に戻しました`
          // 戻る局面は現在の局面の過去の局面なのでSFENを元に戻さない
        } else {
          // 戻る局面は現在の局面とまったく異なるのでSFENごと変更する
          message = `局面を変更しました`
          this.current_sfen = action_log.sfen
        }
        this.current_turn = action_log.turn
      } else {
        message = "局面を戻しました"
        this.current_sfen = action_log.sfen
        this.current_turn = action_log.turn
      }

      this.honpu_branch_clear()

      if (this.ac_room) {
        this.$nextTick(() => this.quick_sync(`${this.my_call_name}が${message}`))
      }
    },
  },
}
