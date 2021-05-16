import { KomaochiPresetInfo } from "@/components/models/komaochi_preset_info.js"
import KomaochiSetModal from "./KomaochiSetModal.vue"

export const app_komaochi_set = {
  data() {
    return {
      komaochi_preset_key: "平手",
    }
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    komaochi_set_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: KomaochiSetModal,
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

    komaochi_preset_info_dropdown_active_change(e) {
    },

    komaochi_preset_info_set_handle(e) {
      // this.current_sfen = e.sfen
      this.komaochi_preset_key = e.key
    },

  },
  computed: {
    KomaochiPresetInfo() { return KomaochiPresetInfo },
    komaochi_preset_info() { return this.KomaochiPresetInfo.fetch(this.komaochi_preset_key) },
  },
}
