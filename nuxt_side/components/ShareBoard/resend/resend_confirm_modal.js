import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import ResendConfirmModal from "./ResendConfirmModal.vue"

export const resend_confirm_modal = {
  data() {
    return {
      resend_confirm_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.resend_confirm_modal_close()
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    // 「対局を中断する」
    resend_confirm_break_handle() {
      this.sfx_click()
      this.resend_done()
      this.cc_silent_pause_share()
      const full_message = [
        `${this.my_call_name}が時計を一時停止しました`,
      ]
      if (this.resend_next_user_name) {
        const missing_user = this.user_call_name(this.resend_next_user_name)
        full_message.push(`${missing_user}が抜けた場合は順番設定から外して再開してください`)
      }
      this.al_share({label: "対局中断", label_type: "is-danger", full_message: full_message})
    },

    // 「再送する」
    resend_confirm_execute_handle() {
      this.sfx_click()
      this.resend_done()
      this.sfen_sync()
    },

    ////////////////////////////////////////////////////////////////////////////////

    resend_confirm_modal_open() {
      this.sfx_play("x")
      this.resend_failed_logging()
      this.resend_done()
      this.resend_confirm_modal_instance = this.modal_card_open({
        component: ResendConfirmModal,
        canCancel: [],
      })
    },

    resend_confirm_modal_close() {
      if (this.resend_confirm_modal_instance) {
        this.resend_confirm_modal_instance.close()
        this.resend_confirm_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
  computed: {
  },
}
