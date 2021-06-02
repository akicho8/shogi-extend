import { HandicapPresetInfo } from "@/components/models/handicap_preset_info.js"
import HandicapSetModal from "./HandicapSetModal.vue"

export const app_handicap_set = {
  data() {
    return {
      handicap_preset_key: "平手",
    }
  },

  created() {
    this.sfen_set_by_url_params()
  },

  methods: {
    // 引数でプリセットの初期値設定
    // http://0.0.0.0:4000/share-board?handicap_preset_key=八枚落ち
    // これいらんか？
    sfen_set_by_url_params() {
      const v = this.$route.query.handicap_preset_key
      if (v) {
        this.handicap_preset_key = v
        const info = this.HandicapPresetInfo.fetch(v)
        this.current_sfen = info.sfen
      }
    },

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
