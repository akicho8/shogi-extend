import _ from "lodash"

export const mod_support = {
  methods: {
    banana_edit_handle() {
      if (this.owner_p) {
        this.sfx_click()
        this.$router.push({name: "video-studio-banana_key-edit", params: {banana_key: this.banana.key}})
      }
    },
    tweet_handle() {
      this.sfx_click()
      this.tweet_window_popup({text: this.tweet_body_wrap()})
    },
    tweet_body_wrap() {
      let out = ""
      out += "\n"
      out += this.banana.tweet_body
      out += " "
      out += this.location_url_without_search_and_hash()
      return out
    },
    tag_click_handle(tag) {
      this.sfx_click()
      this.talk(tag)
      this.$router.push({name: "video", query: {tag: tag}})
    },
    download_handle() {
      this.sfx_click()
      this.$GX.delay_block(1, () => this.toast_primary("ダウンロードしました"))
    },
  },
}
