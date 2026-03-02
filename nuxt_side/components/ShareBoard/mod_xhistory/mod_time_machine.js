import { GX } from "@/components/models/gx.js"
import TimeMachineModal from "./TimeMachineModal.vue"

export const mod_time_machine = {
  methods: {
    // 「この局面に移動しますか？」のダイアログ発動
    time_machine_modal_open_handle(xhistory_record) {
      this.sfx_click()
      this.modal_card_open({
        component: TimeMachineModal,
        props: {
          xhistory_record: xhistory_record,
        },
      })
    },

    time_machine_modal_close_handle() {
      this.sfx_click()
      this.$emit("close")
    },

    time_machine_modal_apply_handle() {
      this.sfx_click()
      this.xhistory_restore({...this.xhistory_record, turn: this.new_turn})
      this.$emit("close")
    },

    // 局面を復元する
    xhistory_restore(attrs) {
      GX.assert('sfen' in attrs, "'sfen' in attrs")
      GX.assert('turn' in attrs, "'turn' in attrs")

      if (XHISTORY_SAME_SFEN_SKIP) {
        if (this.current_sfen === attrs.sfen && this.current_turn === attrs.turn) {
          this.toast_primary("同じ局面です")
          return
        }
      }

      this.honpu_branch_clear()

      {
        let reflector_params = { sfen: attrs.sfen, turn: attrs.turn }
        if (XHISTORY_TURN_ONLY_REVERT) {
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
