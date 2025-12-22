// 反則したら負け

import IllegalLoseModal from "./IllegalLoseModal.vue"
import { GX } from "@/components/models/gx.js"

export const illegal_lose_modal = {
  data() {
    return {
      illegal_lose_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.illegal_lose_modal_close()
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    illegal_lose_modal_open(params) {
      if (GX.present_p(params.illegal_hv_list)) {
        this.illegal_params_set(params)
        this.sfx_stop_all()
        this.sfx_play("lose")
        this.illegal_lose_modal_close()
        this.illegal_lose_modal_instance = this.modal_card_open({
          component: IllegalLoseModal,
          canCancel: [],
          onCancel: () => { throw new Error("must not happen") },
        })
      }
    },

    illegal_lose_modal_close_handle() {
      if (this.illegal_lose_modal_instance) {
        this.sfx_click()
        this.illegal_lose_modal_close()
      }
    },

    illegal_lose_modal_close() {
      if (this.illegal_lose_modal_instance) {
        this.illegal_lose_modal_instance.close()
        this.illegal_lose_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
