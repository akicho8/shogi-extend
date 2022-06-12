export const app_chore = {
  methods: {
    any_source_edit_handle() {
      this.sound_play_click()
      this.$buefy.dialog.confirm({
        title: "共有将棋盤で編集しますか？",
        message: "あっちのメニューの「動画変換」で戻ってこれます",
        cancelText: "キャンセル",
        confirmText: "編集する",
        // focusOn: "confirm", // confirm or cancel
        animation: "",
        onCancel: () => this.sound_play_click(),
        onConfirm: () => {
          this.sound_play_click()
          const params = { any_source: this.body || "平手" , to_format: "sfen" }
          this.$axios.$post("/api/general/any_source_to.json", params).then(e => {
            this.bs_error_message_dialog(e)
            if (e.body) {
              this.$router.push({name: "share-board", query: { body: e.body, abstract_viewpoint: this.viewpoint_key }})
            }
          })
        },
      })
    },
  },
}
