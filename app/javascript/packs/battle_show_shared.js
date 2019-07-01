import _ from "lodash"
import dayjs from "dayjs"

export default {
  data() {
    return {
      kifu_type_tab_index: 0,
    }
  },

  watch: {
  },

  methods: {
    printer_handle() {
      window.print()
    },
  },

  mounted() {
    if (this.$options.formal_paper) {
      setTimeout(function () {
        window.print()
        // window.close()
      }, 200)
    }
  },

  computed: {
  },
}
