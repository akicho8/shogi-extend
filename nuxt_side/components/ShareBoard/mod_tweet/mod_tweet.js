import SbTweetModal from "./SbTweetModal.vue"

export const mod_tweet = {
  methods: {
    tweet_modal_handle() {
      // this.sidebar_close()
      this.sfx_click()
      this.modal_card_open({component: SbTweetModal})
    },

    async tweet_handle() {
      // this.sidebar_close()
      this.sfx_click()
      this.tweet_window_popup({text: await this.tweet_body()})
    },

    // ツイート内容
    // ・1行目に空行を入れて入力しやすくする
    // ・URLの最後にカーソルがあるとツイート追記時にURLを破壊する人がいる
    // ・なので1行目にカーソルを移動した状態で開きたい
    // ・が、Twitterの仕様なのでできない
    async tweet_body() {
      let o = ""
      o += "\n" // 本文を書きやすいように1行目に空行を入れる
      if (this.current_title) {
        o += "#" + this.current_title
      }
      o += "\n"
      o += await this.long_url_to_short_url(this.current_url)
      return o
    },

  },

  computed: {
    // Tweetボタンを表示してもよいですか？
    // 部屋を作ってなくて操作モードのとき
    tweet_button_show_p() {
      return !this.cable_p && this.play_mode_p
    },
  },
}
