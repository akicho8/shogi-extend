export const app_book_message = {
  data() {
    return {
      message_body: null,
      // loading: null,
    }
  },
  created() {
    this.speak_init()
  },
  methods: {
    speak_init() {
      this.message_body = ""
    },
    speak_handle() {
      if (this.present_p(this.message_body)) {
        // this.loading = this.$buefy.loading.open()
        this.speak(this.message_body)
        this.message_body = ""
      }
    },
    speak(message_body) {
      this.ac_book_room_perform("speak", {message_body: message_body}) // --> channels/kiwi/book_room_channel.rb
    },
    speak_broadcasted(params) {
      this.sound_play("click")
      this.base.book.book_messages.push(params.book_message)
      this.talk(params.book_message.body)
      // this.loading.close()
    },
    ////////////////////////////////////////////////////////////////////////////////
    message_decorate(str) {
      str = this.auto_link(str)
      str = this.simple_format(str)
      // str = this.number_replace_to_book_link(str)
      return str
    },

    // 時間にリンクする
    // number_replace_to_book_link(s) {
    //   return s.replace(/#(\d+)/, '<a href="/kiwi?book_id=$1">#$1</a>')
    // },
  },
}
