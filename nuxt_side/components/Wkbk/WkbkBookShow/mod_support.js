import WkbkBookShowDesc from "./WkbkBookShowDesc.vue"

// import dayjs from "dayjs"
import _ from "lodash"

export const mod_support = {
  methods: {
    book_edit_handle() {
      if (this.owner_p) {
        this.sfx_click()
        this.$router.push({name: "rack-books-book_key-edit", params: {book_key: this.book.key}})
      }
    },
    article_show_handle() {
      if (this.current_article_show_p) {
        this.sfx_click()
        if (false) {
          this.$router.push({name: "rack-articles-article_key", params: {article_key: this.current_article.key}})
        } else {
          const e = this.$router.resolve({name: "rack-articles-article_key", params: {article_key: this.current_article.key}})
          this.other_window_open(e.href)
        }
      }
    },
    article_edit_handle() {
      if (this.current_article_edit_p) {
        this.sfx_click()
        if (false) {
          this.$router.push({name: "rack-articles-article_key-edit", params: {article_key: this.current_article.key}})
        } else {
          const e = this.$router.resolve({name: "rack-articles-article_key-edit", params: {article_key: this.current_article.key}})
          this.other_window_open(e.href)
        }
      }
    },
    article_new_handle() {
      if (this.owner_p) {
        this.sfx_click()
        this.$router.push({name: "rack-articles-new", query: {book_key: this.book.key}})
      }
    },
    book_tweet_handle() {
      this.sfx_click()
      this.tweet_window_popup({text: this.tweet_body_wrap(null)})
    },
    tweet_body_wrap(str) {
      let out = ""
      out += "\n"
      if (str) {
        out += str
      }
      out += this.book.tweet_body + " "
      out += this.location_url_without_search_and_hash()
      return out
    },

    description_handle() {
      this.sfx_click()
      this.sfx_stop_all()
      this.talk(this.book.description)
      this.modal_card_open({
        component: WkbkBookShowDesc,
        props: { base: this.base },
        onCancel:  () => {
          this.sfx_stop_all()
          this.sfx_click()
        },
      })
    },
    // second_to_m_ss() {
    //   return dayjs.unix(this.spent_sec).format("m:ss")
    // },
    tag_search_handle(tag) {
      this.sfx_click()
      this.talk(tag)
      this.$router.push({name: "rack", query: {tag: tag}})
    },
  },
  computed: {
    current_article_show_p() { return this.current_xitem },
  },
}
