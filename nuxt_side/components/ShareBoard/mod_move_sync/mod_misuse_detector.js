import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import MisuseModal from "./MisuseModal.vue"
import { MisuseDetector } from "./misuse_detector.js"

export const mod_misuse_detector = {
  data() {
    return {
      misuse_detector: MisuseDetector.create({
        callback: this.misuse_modal_open_handle,
        count_max: this.param_to_i("MISUSE_DETECTOR_COUNT_MAX", 3),
      }),
    }
  },
  beforeDestroy() {
    this.misuse_modal_close()
  },
  methods: {
    // 感想戦モードで対局している人がいないか調べる
    misuse_detector_call(e) {
      if (this.misuse_detector_feature_p) {
        if (this.order_clock_both_empty) {
          this.misuse_detector.call({location_key: e.last_move_info.player_location.key, turn: e.turn})
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    misuse_modal_open_handle() {
      if (!this.misuse_modal_instance) {
        this.sfx_play("se_notification")
        this.misuse_modal_open()
      }
    },

    misuse_modal_close_handle() {
      if (this.misuse_modal_instance) {
        this.sfx_click()
        this.misuse_modal_close()
      }
    },

    ////////////////////////////////////////

    misuse_modal_open() {
      if (!this.misuse_modal_instance) {
        this.modal_card_open2("misuse_modal_instance", {
          component: MisuseModal,
          onCancel: () => {
            this.sfx_click()
            this.misuse_modal_close()
          },
        })
      }
    },

    misuse_modal_close() {
      if (this.misuse_modal_instance) {
        this.modal_card_close2("misuse_modal_instance")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
