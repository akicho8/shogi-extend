import battle_index_shared from "./battle_index_shared.js"

window.SwarsBattleIndex = Vue.extend({
  mixins: [battle_index_shared],

  data() {
    return {
      submited: false,
      detailed: false,
    }
  },

  mounted() {
  },

  methods: {
    many_import_handle(e) {
      this.$dialog.confirm({
        // title: "どうする？",
        message: "1分ぐらいかかる場合がありますがよろしいですか？",
        confirmText: "実行する",
        cancelText: "やめとく",
        focusOn: "cancel",
        onConfirm: () => {
          this.process_now()
          this.$refs.many_import_link.click()
        },
        onCancel: () => {
          this.talk("やめときました")
        },
      })
    },

    form_submited(e) {
      this.process_now()

      this.submited = true
    },
  },
})
