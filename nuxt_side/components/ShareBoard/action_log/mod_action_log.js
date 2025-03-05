// 履歴
// タップ局面変更

const AL_RECORDS_MAX    = 200   // 履歴の最大長
const AL_PUSH_TO        = "top" // 追加位置
const AL_SAME_SFEN_SKIP = false // 同じ局面なら何もしない？

import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import dayjs from "dayjs"
import ActionLogModal from "./ActionLogModal.vue"
import { ActionLogDto } from "./action_log_dto.js"

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

      return ActionLogDto.create(params)
    },

    al_add(params) {
      const action_log_dto = this.al_create(params)
      if (AL_PUSH_TO === "top") {
        this.action_logs.unshift(action_log_dto)
        this.action_logs = _.take(this.action_logs, AL_RECORDS_MAX)
      } else {
        this.action_logs.push(action_log_dto)
        this.action_logs = _.takeRight(this.action_logs, AL_RECORDS_MAX)
        this.$nextTick(() => this.al_scroll_to_bottom())
      }
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
      this.$sound.play_click()
      this.modal_card_open({
        component: ActionLogModal,
        props: {
          action_log: action_log,
        },
      })
    },

    // 局面を復元する
    al_restore(action_log) {
      Gs.assert('sfen' in action_log, "'sfen' in action_log")
      Gs.assert('turn' in action_log, "'turn' in action_log")

      if (AL_SAME_SFEN_SKIP) {
        if (this.current_sfen === action_log.sfen && this.current_turn === action_log.turn) {
          this.toast_ok("同じ局面です")
          return
        }
      }

      this.current_sfen = action_log.sfen
      this.current_turn = action_log.turn

      this.honpu_branch_clear()

      if (this.ac_room) {
        this.$nextTick(() => this.quick_sync(`${this.user_call_name(this.user_name)}が局面を戻しました`))
      }
    },
  },
}
