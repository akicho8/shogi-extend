import { GX } from "@/components/models/gx.js"
import _ from "lodash"

import { BoardPresetInfo } from "@/components/models/board_preset_info.js"
import BoardPresetModal from "./BoardPresetModal.vue"

export const mod_board_preset = {
  data() {
    return {
      board_preset_modal_instance: null,
    }
  },
  created() {
    this.sfen_set_by_url_params()
  },
  beforeDestroy() {
    this.board_preset_modal_close()
  },
  methods: {
    // 起動時に変更する用
    // http://localhost:4000/share-board?board_preset_key=八枚落ち
    // これ使ってない？
    sfen_set_by_url_params() {
      const key = this.$route.query.board_preset_key
      if (key) {
        this.board_preset_key = key
        this.current_sfen = this.board_preset_info.sfen
      }
    },

    // 適用ボタンを押したとき
    board_preset_apply_handle() {
      this.sfx_click()
      this.board_preset_modal_close()

      this.current_turn = 0
      this.current_sfen = this.board_preset_info.sfen
      this.ac_log({subject: "手合割反映", body: this.board_preset_info.name})
      this.force_sync(`${this.my_call_name}が${this.board_preset_info.name}に変更しました`)
    },

    // select UI や ←→ ボタンを押したとき
    board_preset_step_handle(v) {
      this.sfx_click()
      const index = this.board_preset_info.code + v
      const new_index = GX.imodulo(index, this.BoardPresetInfo.values.length)
      const board_preset_info = this.BoardPresetInfo.fetch(new_index)
      this.board_preset_key = board_preset_info.key
    },

    ////////////////////////////////////////////////////////////////////////////////

    board_preset_modal_open_handle() {
      if (this.board_preset_modal_instance == null) {
        this.sidebar_close()
        this.sfx_click()
        this.board_preset_modal_open()
      }
    },
    board_preset_modal_close_handle() {
      if (this.board_preset_modal_instance) {
        this.sfx_click()
        this.board_preset_modal_close()
      }
    },
    board_preset_modal_open() {
      if (this.board_preset_modal_instance == null) {
        this.board_preset_modal_instance = this.modal_card_open({
          component: BoardPresetModal,
          onCancel: () => this.board_preset_modal_close(),
        })
      }
    },
    board_preset_modal_close() {
      if (this.board_preset_modal_instance) {
        this.board_preset_modal_instance.close()
        this.board_preset_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
  computed: {
    BoardPresetInfo()   { return BoardPresetInfo                                   },
    board_preset_info() { return this.BoardPresetInfo.fetch(this.board_preset_key) },
  },
}
