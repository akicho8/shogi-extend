import WkbkBookShowDesc from "./WkbkBookShowDesc.vue"

export const app_support = {
  methods: {
    book_edit_handle() {
      if (this.base.owner_p) {
        this.sound_play("click")
        this.$router.push({name: "library-books-book_id-edit", params: {book_id: this.book.id}})
      }
    },
    article_show_handle() {
      if (this.article_show_p) {
        this.sound_play("click")
        if (false) {
          this.$router.push({name: "library-articles-article_id", params: {article_id: this.current_article.id}})
        } else {
          const e = this.$router.resolve({name: "library-articles-article_id", params: {article_id: this.current_article.id}})
          this.other_window_open(e.href)
        }
      }
    },
    article_new_handle() {
      if (this.article_new_p) {
        this.sound_play("click")
        this.$router.push({name: "library-articles-new", params: {book_id: this.book.id}})
      }
    },
    book_tweet_handle() {
      this.sound_play("click")
      this.tweet_window_popup({text: this.book.tweet_body})
    },
    description_handle() {
      this.sound_play("click")
      this.talk_stop()
      this.talk(this.book.description)
      this.$buefy.modal.open({
        component: WkbkBookShowDesc,
        parent: this,
        props: { base: this.base },
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel:  () => {
          this.talk_stop()
          this.sound_play("click")
        },
      })
    },
  },
  computed: {
    article_show_p() {
      return this.current_article
    },
    article_new_p() {
      return this.g_current_user && this.owner_p
    },
  },
}
