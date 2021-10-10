export const app_banana_message = {
  data() {
    return {
      message_body: null,       // localStorage に保存する
      // loading: null,
    }
  },
  // created() {
  //   // this.speak_init()
  // },
  methods: {
    // speak_init() {
    //   this.message_body = ""
    // },
    speak_handle() {
      if (this.present_p(this.message_body)) {
        // this.loading = this.$buefy.loading.open()
        this.speak(this.message_body)
        this.message_body = ""
      }
    },
    speak(message_body) {
      this.ac_banana_room_perform("speak", {message_body: message_body}) // --> channels/kiwi/banana_room_channel.rb
    },
    speak_broadcasted(params) {
      this.sound_play("click")
      this.base.banana.banana_messages.push(params.banana_message)
      this.talk(params.banana_message.body)
      // this.loading.close()
    },
    ////////////////////////////////////////////////////////////////////////////////
    message_decorate(str) {
      str = this.auto_link(str)
      str = this.simple_format(str)
      // str = this.number_replace_to_banana_link(str)
      return str
    },

    // 時間にリンクする
    // number_replace_to_banana_link(s) {
    //   return s.replace(/#(\d+)/, '<a href="/kiwi?banana_id=$1">#$1</a>')
    // },
  },
}
