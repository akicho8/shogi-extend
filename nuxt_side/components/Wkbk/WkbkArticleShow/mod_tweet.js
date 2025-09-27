import _ from "lodash"
import QueryString from "query-string"

export const mod_tweet = {
  methods: {
    tweet_handle() {
      this.sfx_play_click()
      this.tweet_window_popup({text: this.tweet_body})
    },
  },
  computed: {
    current_url_params() {
      return {}
    },
    current_url() {
      return QueryString.stringifyUrl({
        url: this.$config.MY_SITE_URL + `/rack/articles/${this.article.key}`,
        query: this.current_url_params,
      })
    },
    tweet_body() {
      let out = ""
      out += this.article.tweet_body + " "
      out += this.location_url_without_search_and_hash()
      return out
    },
  },
}
