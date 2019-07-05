import _ from "lodash"
import dayjs from "dayjs"

export default {
  data() {
    return {
      kifu_type_tab_index: 0,
      record: this.$options.record,
      decorator: this.$options.decorator,
      desc_body_edit_p: false,
    }
  },

  watch: {
  },

  methods: {
    printer_handle() {
      window.print()
    },

    desc_body_click_handle() {
      if (!this.desc_body_edit_p) {
        this.desc_body_edit_p = true
        this.$nextTick(() => this.$refs.desc_body_edit_ref.focus())
      }
    },

  },

  mounted() {
    if (this.$options.formal_sheet) {
      setTimeout(function () {
        // window.print()
        // window.close()
      }, 200)
    }
  },

  computed: {
  },
}
