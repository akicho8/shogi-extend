export const app_book_delete = {
  methods: {
    delete_handle(book) {
      this.sound_play("click")
      if (book.new_record_p) {
        this.toast_warn("まだ保存していません")
      } else {
        this.dialog_confirm({
          type: "is-danger",
          message: "本当に削除してもよいか？",
          confirmText: "削除する",
          focusOn: "cancel",
          onConfirm: () => {
            this.sound_play("click")
            this.$axios.$delete("/api/kiwi/books/destroy.json", {params: {book_id: book.id}}).then(e => {
              this.toast_ok("削除しました")
              this.$router.push({name: "video-books"})
            })
          },
        })
      }
    },
  },
}
