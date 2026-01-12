import { GX } from "@/components/models/gx.js"
import EndingModal from "./EndingModal.vue"

export const ending_modal = {
  data() {
    return {
      ending_modal_instance: null,
    }
  },

  beforeDestroy() {
    this.ending_modal_close()
  },

  methods: {
    ending_modal_open() {
      this.ending_modal_close()
      this.ending_modal_instance = this.modal_card_open({
        component: EndingModal,
        onCancel: () => this.ending_modal_close(),
      })
    },

    ending_modal_close_handle() {
      this.sfx_click()
      this.ending_modal_close()
    },

    ending_modal_close() {
      if (this.ending_modal_instance) {
        this.ending_modal_instance.close()
        this.ending_modal_instance = null
      }
    },
  },
}
