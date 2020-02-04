import _ from "lodash"
import dayjs from "dayjs"
import battle_record_methods from "battle_record_methods.js"

export default {
  mixins: [battle_record_methods],

  data() {
    return {
      record: this.$options.record,
      decorator: this.$options.decorator,
      kifu_type_tab_index: 0,
    }
  },

  watch: {
  },

  methods: {
    printer_handle() {
      window.print()
    },

    edit_to(key) {
      this.$buefy.dialog.prompt({
        title: "編集",
        inputAttrs: {type: "text", value: this.decorator[key], required: false},
        confirmText: "更新",
        cancelText: "キャンセル",
        onConfirm: (value) => {
          if (this.decorator[key] !== value) {
            this.$set(this.decorator, key, value)
            this.$buefy.toast.open({message: `更新しました`, position: "is-bottom"})
          }
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
