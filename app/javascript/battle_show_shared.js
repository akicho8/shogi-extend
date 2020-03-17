import _ from "lodash"
import dayjs from "dayjs"
import battle_record_methods from "battle_record_methods.js"
import formal_sheet from "formal_sheet.js"

export default {
  mixins: [
    battle_record_methods,
    formal_sheet,
  ],

  data() {
    return {
      sp_modal_p: true,

      // const
      record: this.$options.record,
      iframe_p: this.$options.iframe_p,
    }
  },

  watch: {
    sp_modal_p(v) {
      if (v) {
      } else {
        if (this.$options.close_back_path) {
          this.self_window_open(this.$options.close_back_path)
        }
      }
    },
  },

  computed: {
  },
}
