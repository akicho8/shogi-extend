import GiveUpModal from "./GiveUpModal.vue"
import { GX } from "@/components/models/gx.js"

export const give_up_modal = {
  data() {
    return {
      give_up_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.give_up_modal_close()
  },
  methods: {
    give_up_modal_open_handle() {
      this.sfx_click()
      this.give_up_modal_open()
    },
    give_up_modal_close_handle() {
      this.sfx_click()
      this.give_up_modal_close()
    },
    give_up_modal_open() {
      this.give_up_modal_close()
      this.sb_talk(this.give_up_confirm_message)
      this.give_up_modal_instance = this.modal_card_open({
        component: GiveUpModal,
        onCancel: () => this.give_up_modal_close(),
      })
    },
    give_up_modal_close() {
      if (this.give_up_modal_instance) {
        this.give_up_modal_instance.close()
        this.give_up_modal_instance = null
      }
    },
  },
  computed: {
    give_up_confirm_message() {
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
