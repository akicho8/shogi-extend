export const mod_book_delete = {
  methods: {
    download_handle(book) {
      if (book.new_record_p) {
        this.sfx_play_click()
        this.toast_warn("まだ保存していません")
      } else {
        window.location.href = `${this.$config.MY_SITE_URL}/api/wkbk/books/download?book_key=${book.key}`
      }
    },
    
    book_delete_handle(book) {
      this.sfx_play_click()
      if (book.new_record_p) {
        this.toast_warn("まだ保存していません")
      } else {
        this.$buefy.dialog.confirm({
          type: "is-danger",
          hasIcon: true,
          message: "本当に削除してもよいですか？<br><span class='has-text-grey-light'>問題は削除されません</span>",
          cancelText: "キャンセル",
          confirmText: "削除する",
          focusOn: "cancel",
          onCancel: () => {
            this.sfx_play_click()
          },
          onConfirm: () => {
            this.sfx_play_click()
            this.$axios.$delete("/api/wkbk/books/destroy.json", {params: {book_id: book.id}}).then(e => {
              this.toast_ok("削除しました")
              this.$router.push({name: "rack-books"})
            })
          },
        })
      }
    },
  },
}
