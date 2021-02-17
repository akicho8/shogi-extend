export const app_book_delete = {
  methods: {
    download_url(book) {
      return `${this.$config.MY_SITE_URL}/api/wkbk/books/download?book_key=${book.key}`
    },
    
    book_delete_handle(book) {
      this.sound_play("click")
      if (book.new_record_p) {
        this.toast_warn("まだ保存していません")
      } else {
        this.$buefy.dialog.confirm({
          type: "is-danger",
          hasIcon: true,
          message: "本当に削除してもよろしいですか？",
          cancelText: "キャンセル",
          confirmText: "削除する",
          focusOn: "cancel",
          onCancel: () => {
            this.sound_play("click")
          },
          onConfirm: () => {
            this.sound_play("click")
            this.$axios.$delete("/api/wkbk/books/destroy.json", {params: {book_id: book.id}}).catch(e => {
              this.$nuxt.error(e.response.data)
              return
            }).then(e => {
              this.toast_ok("削除しました")
              this.$router.push({name: "rack-books"})
            })
          },
        })
      }
    },
  },
}
