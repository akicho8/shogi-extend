import { BoardPresetInfo } from "@/components/models/board_preset_info.js"
import BoardPresetSelectModal from "./BoardPresetSelectModal.vue"

export const mod_board_preset_select = {
  created() {
    this.sfen_set_by_url_params()
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

    board_preset_select_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.modal_card_open({
        component: BoardPresetSelectModal,
      })
    },
  },
  computed: {
    BoardPresetInfo()   { return BoardPresetInfo                                   },
    board_preset_info() { return this.BoardPresetInfo.fetch(this.board_preset_key) },
  },
}
