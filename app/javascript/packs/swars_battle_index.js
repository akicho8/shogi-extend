import battle_index_shared from "battle_index_shared.js"

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
    player_info_click_hadle(e) {
      this.$dialog.confirm({
        title: "プレイヤー情報",
        message: "20秒ぐらいかかる場合がありますがよろしいですか？",
        confirmText: "表示する",
        cancelText: "やめとく",
        focusOn: "cancel",
        onConfirm: () => {
          this.process_now()
          location.href = this.$options.player_info_path
        },
        onCancel: () => {
          this.talk("やめときました")
        },
      })
    },

    many_import_handle(e) {
      this.$dialog.confirm({
        title: "古い棋譜も取得",
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
