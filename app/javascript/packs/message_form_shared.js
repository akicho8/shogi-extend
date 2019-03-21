// メッセージ送信関連の共通メソッド

export default {
  data() {
    return {
      message: "",
    }
  },
  watch: {
    // メッセージを入力しようとしたときにログインしていなければログインに飛ばす
    message() {
      if (AppHelper.login_required()) {
        return
      }
    },

  },
  methods: {
    // フォームで enter を押したとき装飾キーつきであれば送信する
    message_enter_handle(e) {
      if (e.shiftKey || e.ctrlKey || e.altKey || e.metaKey) {
        e.preventDefault()
        this.message_post_button_handle()
      }
    },

    // 「送信」ボタンを押したとき
    message_post_button_handle() {
      if (AppHelper.login_required()) {
        return
      }
      if (this.message !== "") {
        this.message_send_process() // mixins した先で定義する
      }
      this.message = ""
      if (this.$refs.message_input) {
        this.$refs.message_input.focus()
      }
    },
  },
}
