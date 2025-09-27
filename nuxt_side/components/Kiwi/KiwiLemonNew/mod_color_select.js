import ColorSelectModal from "./ColorSelectModal.vue"
import { ColumnSizeInfo } from "../../models/column_size_info.js"

export const mod_color_select = {
  data() {
    return {
      column_size_code: null,
    }
  },
  methods: {
    color_select_modal_handle() {
      this.sidebar_p = false
      this.sfx_play_click()
      this.modal_card_open({
        component: ColorSelectModal,
        props: { base: this.base },
      })
    },
  },
  computed: {
    ColumnSizeInfo() { return ColumnSizeInfo },
    column_size_info() { return ColumnSizeInfo.fetch(this.column_size_code) },
  },
}
