const LOBBY_MESSAGE_BODY_NOIZE_CHECK_DAYS = 2 * 7

export const application_lobby_message = {
  data() {
    return {
      lobby_messages:     null, // メッセージ(複数)
      lobby_message_body: null, // 入力中のメッセージ
    }
  },

  methods: {
    // 送信ボタンが押されたとき
    lobby_speak_handle() {
      if (this.lobby_speak_reject()) { return }
      this.lobby_speak(this.lobby_message_body)
      this.lobby_message_body = ""
    },

    // ゴミを除去
    lobby_speak_reject() {
      if (this.lobby_message_body_is_noize_p) {
        this.lobby_message_body = ""
        this.warning_notice("ゴミを投函しないでください")
        return
      }
    },

    // 発言
    lobby_speak(message_body) {
      this.$ac_lobby.perform("speak", {message_body: message_body})
    },

    // 受信
    lobby_speak_broadcasted(params) {
      if (this.base.current_user && this.base.current_user.mute_user_ids.includes(params.message.user.id)) {
        this.debug_alert(`skip: ${params.message.body}`)
        return
      }
      this.lobby_speak_broadcasted_shared_process(params)
      this.lobby_messages.push(params.message)
    },

    // room_speak_broadcasted と共有
    lobby_speak_broadcasted_shared_process(params) {
      const message = params.message
      if (/^\*/.test(message.body)) {
      } else {
        const plain_text = this.strip_tags(message.body)
        if (plain_text) {
          this.say(plain_text)
          this.$buefy.toast.open({message: `${message.user.name}: ${plain_text}`, position: "is-top", queue: false})
        }
      }
    },
  },

  computed: {
    // 入力された文字列はゴミか？
    // ゴミを投函するのは新規ユーザーだけなので最初の2週間だけチェックする
    lobby_message_body_is_noize_p() {
      let s = this.lobby_message_body || ""
      s = s.replace(/\s+/g, "")          // s = s.remove(" ")
      s = _.uniq(Array.from(s)).join("") // s = s.chars.uniq.join
      const retv = s.length === 1
      if (this.base.current_user) {
        if (this.base.current_user.created_after_days <= LOBBY_MESSAGE_BODY_NOIZE_CHECK_DAYS) {
          return retv
        }
      }
    },
  },
}
