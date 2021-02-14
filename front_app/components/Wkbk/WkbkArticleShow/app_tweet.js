import _ from "lodash"

export const app_tweet = {
  methods: {
    tweet_handle() {
      this.sound_play("click")
      this.tweet_window_popup({text: this.tweet_body})
    },
  },
  computed: {
    current_url_params() {
      return {}
    },
    current_url() {
      let url = new URL(this.$config.MY_SITE_URL + `/rack/articles/${this.article.key}`)
      _.each(this.current_url_params, (v, k) => {
        url.searchParams.set(k, v)
      })
      return url.toString()
    },
    tweet_body() {
      let out = ""
      out += "#" + "インスタント将棋問題集" + "\n"
      out += this.article.title + "\n"
      out += this.current_url
      return out
    },
  },
}
