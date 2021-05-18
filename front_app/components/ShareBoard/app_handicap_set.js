import { HandicapPresetInfo } from "@/components/models/handicap_preset_info.js"
import HandicapSetModal from "./HandicapSetModal.vue"

export const app_handicap_set = {
  data() {
    return {
      handicap_preset_key: "平手",
    }
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    handicap_set_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: HandicapSetModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
        },
      })
    },
  },
  computed: {
    HandicapPresetInfo()   { return HandicapPresetInfo                                      },
    handicap_preset_info() { return this.HandicapPresetInfo.fetch(this.handicap_preset_key) },
  },
}
