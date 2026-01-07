import EndingModal from "./EndingModal.vue"
import { GX } from "@/components/models/gx.js"

export const ending_modal = {
  data() {
    return {
      ending_modal_instance: null,
      ending_params: null,
    }
  },
  beforeDestroy() {
    this.ending_modal_close()
  },
  methods: {
    ending_modal_close_handle() {
      this.sfx_click()
      this.ending_modal_close()
    },
    ending_modal_open(params) {
      this.ending_params = params
      this.ending_modal_close()
      this.ending_modal_instance = this.modal_card_open({
        component: EndingModal,
        onCancel: () => this.ending_modal_close(),
      })
    },
    ending_modal_close() {
      if (this.ending_modal_instance) {
        this.ending_modal_instance.close()
        this.ending_modal_instance = null
      }
    },
  },
  computed: {
    ending_message() {
      if (this.ending_params) {
        const location_key = this.ending_params.win_location_key
        if (location_key) {
          const location = this.Location.fetch(location_key)
          if (this.ending_params.checkmate) {
            return `詰みで${location.name}の勝ち`
          } else {
            return `投了で${location.name}の勝ち`
          }
        } else {
          return "引き分け"
        }
      }
    },
  },
}
