import { GX } from "@/components/models/gx.js"
import TimeMachineModal from "./TimeMachineModal.vue"

export const mod_time_machine = {
  data() {
    return {
    }
  },
  beforeDestroy() {
    this.time_machine_modal_close()
  },
  methods: {
    // 本譜用
    time_machine_modal_open_handle_for_honpu(xhistory_record) {
      const timeline_resolver_params = {
        message_prefix: "本譜の",
        fast_forward: false,
      }
      this.time_machine_modal_open_handle({
        xhistory_record,
        timeline_resolver_params,
      })
    },

    // 履歴用
    time_machine_modal_open_handle_for_history(xhistory_record) {
      const timeline_resolver_params = {
      }
      this.time_machine_modal_open_handle({
        xhistory_record,
        timeline_resolver_params,
      })
    },

    time_machine_modal_open_handle(params) {
      // this.sidebar_close()
      this.sfx_click()
      this.time_machine_modal_open(params)
    },

    time_machine_modal_close_handle() {
      // this.sidebar_close()
      this.sfx_click()
      this.time_machine_modal_close()
    },

    time_machine_modal_open(params) {
      this.time_machine_modal_close()
      this.time_machine_modal_instance = this.modal_card_open({
        component: TimeMachineModal,
        props: params,
        onCancel: () => {
          this.sfx_click()
          this.time_machine_modal_close()
        },
      })
    },

    time_machine_modal_close() {
      if (this.time_machine_modal_instance) {
        this.time_machine_modal_instance.close()
        this.time_machine_modal_instance = null
      }
    },

    time_machine_modal_apply_handle(params) {
      this.time_machine_modal_close()
      this.time_machine_restore(params)
    },

    time_machine_restore(params) {
      GX.assert('sfen' in params, "'sfen' in params")
      GX.assert('turn' in params, "'turn' in params")
      this.honpu_branch_clear()
      this.reflector_call(params)
    },
  },
}
