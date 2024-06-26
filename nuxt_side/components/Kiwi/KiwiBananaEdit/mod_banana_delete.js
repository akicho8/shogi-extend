export const mod_banana_delete = {
  methods: {
    delete_handle(banana) {
      this.$sound.play_click()
      if (banana.new_record_p) {
        this.toast_warn("まだ保存していません")
      } else {
        this.dialog_confirm({
          type: "is-danger",
          message: "本当に削除してもよいですか？",
          confirmText: "削除する",
          focusOn: "cancel",
          onConfirm: () => {
            this.$sound.play_click()
            this.$axios.$delete("/api/kiwi/bananas/destroy.json", {params: {banana_id: banana.id}}).then(e => {
              this.toast_ok("削除しました")
              this.$router.push({name: "video-studio"})
            })
          },
        })
      }
    },
  },
}
