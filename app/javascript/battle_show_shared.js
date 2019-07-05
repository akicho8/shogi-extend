import _ from "lodash"
import dayjs from "dayjs"

export default {
  data() {
    return {
      inline_edit_p: false,
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
      if (this.inline_edit_p) {
        if (!this.desc_body_edit_p) {
          this.desc_body_edit_p = true
          this.$nextTick(() => this.$refs.desc_body_edit_ref.focus())
        }
      } else {
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
