import { BoardPresetInfo } from "@/components/models/board_preset_info.js"
import PresetSelectModal from "./PresetSelectModal.vue"

export const mod_preset_select = {
  data() {
    return {
      preset_select_modal_instance: null,
    }
  },

  created() {
    this.sfen_set_by_url_params()
  },

  beforeDestroy() {
    this.preset_select_modal_close()
  },

  methods: {
    // FIXME: 取る
    // 引数でプリセットの初期値設定
    // http://localhost:4000/share-board?board_preset_key=八枚落ち
    // これいらんか？
    sfen_set_by_url_params() {
      const v = this.$route.query.board_preset_key
      if (v) {
        this.board_preset_key = v
        const info = this.BoardPresetInfo.fetch(v)
        this.current_sfen = info.sfen
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    preset_select_modal_open_handle() {
      if (this.preset_select_modal_instance == null) {
        this.sidebar_p = false
        this.sfx_click()
        this.preset_select_modal_instance = this.modal_card_open({
          component: PresetSelectModal,
          onCancel: () => this.preset_select_modal_close(),
        })
      }
    },

    preset_select_modal_close() {
      if (this.preset_select_modal_instance) {
        this.preset_select_modal_instance.close()
        this.preset_select_modal_instance = null
        this.debug_alert("PresetSelectModal close")
      }
    },
  },
  computed: {
    BoardPresetInfo()   { return BoardPresetInfo                                   },
    board_preset_info() { return this.BoardPresetInfo.fetch(this.board_preset_key) },
  },
}
