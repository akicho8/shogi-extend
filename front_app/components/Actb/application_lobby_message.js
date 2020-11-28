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
      this.lobby_speak(this.lobby_message_body)
      this.lobby_message_body = ""
    },

    // 発言
    lobby_speak(message_body) {
      this.$ac_lobby.perform("speak", {message_body: message_body})
    },

    // 受信
    lobby_speak_broadcasted(params) {
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
}
