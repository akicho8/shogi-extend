export const mod_article_delete = {
  methods: {
    article_delete_handle(article) {
      this.sfx_play_click()
      if (article.new_record_p) {
        this.toast_warn("まだ保存していません")
      } else {
        this.$buefy.dialog.confirm({
          type: "is-danger",
          hasIcon: true,
          message: "本当に削除してもよいですか？",
          cancelText: "キャンセル",
          confirmText: "削除する",
          focusOn: "cancel",
          onCancel: () => {
            this.sfx_play_click()
          },
          onConfirm: () => {
            this.sfx_play_click()
            this.$axios.$delete("/api/wkbk/articles/destroy.json", {params: {article_id: article.id}}).then(e => {
              this.toast_ok("削除しました")
              this.$router.push({name: "rack-articles"})
            })
          },
        })
      }
    },
  },
}
