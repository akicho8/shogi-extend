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
  },

  computed: {
  },

  filters: {
    hirogeru(value) {
      if (!value) return ""
      return value.toString().split("").join(" ")
    }
  },
}
