const XHISTORY_TURN_ONLY_REVERT = true  // 過去の履歴なら手数だけ戻す？

import { GX } from "@/components/models/gx.js"
import TimeMachineModal from "./TimeMachineModal.vue"

export const mod_time_machine = {
  data() {
    return {
      $time_machine_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.time_machine_modal_close()
  },
  methods: {
    time_machine_modal_open_handle(xhistory_record) {
      // this.sidebar_close()
      this.sfx_click()
      this.time_machine_modal_open(xhistory_record)
    },

    time_machine_modal_close_handle() {
      // this.sidebar_close()
      this.sfx_click()
      this.time_machine_modal_close()
    },

    time_machine_modal_open(xhistory_record) {
      this.time_machine_modal_close()
      this.$time_machine_modal_instance = this.modal_card_open({
        component: TimeMachineModal,
        props: {
          xhistory_record: xhistory_record,
        },
        onCancel: () => {
          this.sfx_click()
          this.time_machine_modal_close()
        },
      })
    },

    time_machine_modal_close() {
      if (this.$time_machine_modal_instance) {
        this.$time_machine_modal_instance.close()
        this.$time_machine_modal_instance = null
      }
    },

    time_machine_modal_apply_handle(attrs) {
      this.time_machine_modal_close()
      this.time_machine_restore(attrs)
    },

    // 局面を復元する
    time_machine_restore(attrs) {
      GX.assert('sfen' in attrs, "'sfen' in attrs")
      GX.assert('turn' in attrs, "'turn' in attrs")

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
