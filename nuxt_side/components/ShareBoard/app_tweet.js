import TweetModal from "./TweetModal.vue"

export const app_tweet = {
  methods: {
    tweet_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.modal.open({
        component: TweetModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        props: { base: this.base },
        onCancel: () => this.sound_play("click"),
      })
    },

    tweet_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      if (false) {
        // この方法だと1行目を空行にできない
        this.tweet_window_popup({url: this.current_url, text: this.tweet_hash_tag})
      } else {
        // 本文を自力で作れば1行目を空行にできる
        this.tweet_window_popup({text: this.tweet_body})
      }
    },
  },

  computed: {
    // Tweetボタンを表示してもよいか？
    // 部屋を作ってなくて操作モードのとき
    tweet_button_show_p() {
      return !this.ac_room && this.play_mode_p
    },

    // ツイート内容
    // ・1行目に空行を入れて入力しやすくする
    // ・URLの最後にカーソルがあるとツイート追記時にURLを破壊する人がいる
    // ・なので1行目にカーソルを移動した状態で開きたい
    // ・が、Twitterの仕様なのでできない
    tweet_body() {
      let o = ""
      o += "\n"
      if (this.current_title) {
        o += "#" + this.current_title
      }
      o += "\n"
      o += this.current_url
      return o
    },
  },
}
