// import dayjs from "dayjs"
import _ from "lodash"

export const app_support = {
  methods: {
    book_edit_handle() {
      if (this.owner_p) {
        this.sound_play("click")
        this.$router.push({name: "video-studio-book_key-edit", params: {book_key: this.book.key}})
      }
    },
    // article_show_handle() {
    //   if (this.current_article_show_p) {
    //     this.sound_play("click")
    //     if (false) {
    //       this.$router.push({name: "video-articles-article_key", params: {article_key: this.current_article.key}})
    //     } else {
    //       const e = this.$router.resolve({name: "video-articles-article_key", params: {article_key: this.current_article.key}})
    //       this.other_window_open(e.href)
    //     }
    //   }
    // },
    // article_edit_handle() {
    //   if (this.current_article_edit_p) {
    //     this.sound_play("click")
    //     if (false) {
    //       this.$router.push({name: "video-articles-article_key-edit", params: {article_key: this.current_article.key}})
    //     } else {
    //       const e = this.$router.resolve({name: "video-articles-article_key-edit", params: {article_key: this.current_article.key}})
    //       this.other_window_open(e.href)
    //     }
    //   }
    // },
    // article_new_handle() {
    //   if (this.owner_p) {
    //     this.sound_play("click")
    //     this.$router.push({name: "video-articles-new", query: {book_key: this.book.key}})
    //   }
    // },
    book_tweet_handle() {
      this.sound_play("click")
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

    // second_to_m_ss() {
    //   return dayjs.unix(this.spent_sec).format("m:ss")
    // },
    tag_append_search_handle(tag) {
      this.sound_play("click")
      this.talk(tag)
      this.$router.push({name: "video", query: {tag: tag}})
    },
  },
  computed: {
    // current_article_show_p() { return this.current_xitem },
  },
}
