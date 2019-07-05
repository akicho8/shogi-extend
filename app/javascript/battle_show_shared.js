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
      this.$dialog.prompt({
        title: "備考",
        inputAttrs: { type: "text", value: this.decorator.desc_body },
        confirmText: "更新",
        cancelText: "キャンセル",
        onConfirm: (value) => {
          this.decorator.desc_body = value
          this.$toast.open("備考を更新しました")
        },
      })
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
