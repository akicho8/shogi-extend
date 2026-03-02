// 履歴
// タップ局面変更

const XHISTORY_RECORDS_MAX      = 200   // 履歴の最大長
const XHISTORY_SAME_SFEN_SKIP   = false // 同じ局面なら何もしない？
const XHISTORY_TURN_ONLY_REVERT = true  // 過去の履歴なら手数だけ戻す？

import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"
import TimeMachineModal from "./TimeMachineModal.vue"
import { XhistoryRecord } from "./xhistory_record.js"
import { mod_xhistory_action      } from "./mod_xhistory_action.js"
import { mod_time_machine      } from "./mod_time_machine.js"

export const mod_xhistory = {
  mixins: [
    mod_xhistory_action,
    mod_time_machine,
  ],
  data() {
    return {
      xhistory_records: [],
    }
  },
  methods: {
    xhistory_create(attrs = {}) {
      attrs = {...attrs}

      // BCではなくローカルの場合もあるので復帰用に棋譜を埋める
      attrs.sfen ??= this.current_sfen
      attrs.turn ??= this.current_turn
      attrs.viewpoint ??= this.viewpoint

      // その他
      attrs.from_user_name ??= this.user_name
      attrs.performed_at ??= this.$time.current_ms()

      // KIF に埋めたいものも合わせて保持しておく
      attrs.player_names_with_title ??= this.player_names_with_title

      return XhistoryRecord.create(attrs)
    },

    xhistory_add(attrs) {
      const xhistory_record = this.xhistory_create(attrs)
      this.xhistory_records = _.take([xhistory_record, ...this.xhistory_records], XHISTORY_RECORDS_MAX)
    },

    xhistory_test() {
      const i = this.xhistory_records.length
      this.xhistory_add({
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
    xhistory_scroll_to_bottom() {
      const e = this.$refs.XhistoryContainer
      if (e) {
        this.$nextTick(() => this.scroll_to_bottom(e.$refs.SideColumnScroll))
      }
    },
  },
}
