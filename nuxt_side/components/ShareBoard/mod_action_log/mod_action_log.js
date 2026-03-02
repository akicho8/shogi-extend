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
import { mod_action_log_share      } from "./mod_action_log_share.js"

export const mod_action_log = {
  mixins: [
    mod_action_log_share,
  ],
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
        last_move_info_attrs: {
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
      const e = this.$refs.SbActionLogContainer
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
    al_restore(attrs) {
      GX.assert('sfen' in attrs, "'sfen' in attrs")
      GX.assert('turn' in attrs, "'turn' in attrs")

      if (AL_SAME_SFEN_SKIP) {
        if (this.current_sfen === attrs.sfen && this.current_turn === attrs.turn) {
          this.toast_primary("同じ局面です")
          return
        }
      }

      this.honpu_branch_clear()

      {
        let reflector_params = { sfen: attrs.sfen, turn: attrs.turn }
        if (AL_TURN_ONLY_REVERT) {
          if (this.current_sfen.startsWith(attrs.sfen)) {
            // 戻る局面は現在の局面の過去の局面なのでSFENを元に戻さない (重要)
            // こうすることで未来方向の棋譜を維持した状態にできる
            // SFEN まで更新すると turn のところまでの SFEN になってしまう
            reflector_params = { turn: attrs.turn }
          }
        }
        this.reflector_call(reflector_params)
      }
    },
  },
}
