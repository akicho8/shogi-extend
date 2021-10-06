import _ from "lodash"

export const app_support = {
  methods: {
    book_edit_handle() {
      if (this.owner_p) {
        this.sound_play("click")
        this.$router.push({name: "video-studio-book_key-edit", params: {book_key: this.book.key}})
      }
    },
    tweet_handle() {
      this.sound_play("click")
      this.tweet_window_popup({text: this.tweet_body_wrap()})
    },
    tweet_body_wrap() {
      let out = ""
      out += "\n"
      out += this.book.tweet_body
      out += " "
      out += this.location_url_without_search_and_hash()
      return out
    },
    tag_click_handle(tag) {
      this.sound_play("click")
      this.talk(tag)
      this.$router.push({name: "video", query: {tag: tag}})
    },
    download_handle() {
      this.sound_play("click")
      this.delay_block(1, () => this.toast_ok("ダウンロードしました"))
    },
  },
}
