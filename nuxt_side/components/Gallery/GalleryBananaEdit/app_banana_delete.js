export const app_banana_delete = {
  methods: {
    delete_handle(banana) {
      this.sound_play("click")
      if (banana.new_record_p) {
        this.toast_warn("まだ保存していません")
      } else {
        this.dialog_confirm({
          type: "is-danger",
          message: "本当に削除してもよいか？",
          confirmText: "削除する",
          focusOn: "cancel",
          onConfirm: () => {
            this.sound_play("click")
            this.$axios.$delete("/api/gallery/bananas/destroy.json", {params: {banana_id: banana.id}}).then(e => {
              this.toast_ok("削除しました")
              this.$router.push({name: "video-studio"})
            })
          },
        })
      }
    },
  },
}
