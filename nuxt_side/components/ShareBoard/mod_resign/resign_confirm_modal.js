import ResignConfirmModal from "./ResignConfirmModal.vue"
import { GX } from "@/components/models/gx.js"

export const resign_confirm_modal = {
  data() {
    return {
      resign_confirm_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.resign_confirm_modal_close()
  },
  methods: {
    resign_confirm_modal_open_handle() {
      this.sfx_click()
      this.resign_confirm_modal_open()
    },
    resign_confirm_modal_close_handle() {
      this.sfx_click()
      this.resign_confirm_modal_close()
    },
    resign_confirm_modal_open() {
      this.resign_confirm_modal_close()
      this.sb_talk(this.resign_confirm_message)
      this.resign_confirm_modal_instance = this.modal_card_open({
        component: ResignConfirmModal,
        onCancel: () => this.resign_confirm_modal_close(),
      })
    },
    resign_confirm_modal_close() {
      if (this.resign_confirm_modal_instance) {
        this.resign_confirm_modal_instance.close()
        this.resign_confirm_modal_instance = null
      }
    },
  },
  computed: {
    resign_confirm_message() {
      let s = null
      if (this.i_am_member_p) {
        if (this.current_turn_self_p) {
          s = "本当に投了しますか？"
        } else {
          s = "手番ではないけど本当に投了しますか？"
        }
      } else {
        s = "対局者ではないけど本当に投了しますか？"
      }
      return s
    },
  },
}
