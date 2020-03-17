export default {
  data() {
    return {
      font_size_limit_off_modal_p: false,
      decorator: this.$options.decorator,
    }
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
}
