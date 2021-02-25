import WkbkBookShowDesc from "./WkbkBookShowDesc.vue"
import { ArticleTitleDisplayInfo } from "../models/article_title_display_info.js"
import { CorrectBehaviorInfo } from "../models/correct_behavior_info.js"

// import dayjs from "dayjs"
import _ from "lodash"

export const app_support = {
  methods: {
    book_edit_handle() {
      if (this.owner_p) {
        this.sound_play("click")
        this.$router.push({name: "rack-books-book_key-edit", params: {book_key: this.book.key}})
      }
    },
    article_show_handle() {
      if (this.current_article_show_p) {
        this.sound_play("click")
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
        this.sound_play("click")
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
        this.sound_play("click")
        this.$router.push({name: "rack-articles-new", query: {book_key: this.book.key}})
      }
    },
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
      this.$router.push({name: "rack", query: {tag: tag}})
    },
  },
  computed: {
    current_article_show_p() { return this.current_xitem },
    ArticleTitleDisplayInfo() { return ArticleTitleDisplayInfo },
    article_title_display_info() { return ArticleTitleDisplayInfo.fetch(this.article_title_display_key) },
    CorrectBehaviorInfo() { return CorrectBehaviorInfo },
    correct_behavior_info() { return CorrectBehaviorInfo.fetch(this.correct_behavior_key) },
  },
}
