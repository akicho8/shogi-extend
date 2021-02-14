import WkbkBookShowDesc from "./WkbkBookShowDesc.vue"
// import dayjs from "dayjs"

export const app_support = {
  methods: {
    book_edit_handle() {
      if (this.base.owner_p) {
        this.sound_play("click")
        this.$router.push({name: "rack-books-book_key-edit", params: {book_key: this.book.key}})
      }
    },
    article_show_handle() {
      if (this.article_show_p) {
        this.sound_play("click")
        if (false) {
          this.$router.push({name: "rack-articles-article_key", params: {article_key: this.current_xitem.article.key}})
        } else {
          const e = this.$router.resolve({name: "rack-articles-article_key", params: {article_key: this.current_xitem.article.key}})
          this.other_window_open(e.href)
        }
      }
    },
    article_new_handle() {
      if (this.owner_p) {
        this.sound_play("click")
        this.$router.push({name: "rack-articles-new", query: {book_key: this.book.key}})
      }
    },
    book_tweet_handle() {
      this.sound_play("click")
      this.tweet_window_popup({text: `\n${this.book.tweet_body}`})
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
    // second_to_m_ss() {
    //   return dayjs.unix(this.spent_sec).format("m:ss")
    // },
    tag_search_handle(tag) {
      this.sound_play("click")
      this.talk(tag)
      this.$router.replace({name: "rack", query: {tag: tag}})
    },
  },
  computed: {
    article_show_p() { return this.current_xitem },
  },
}
