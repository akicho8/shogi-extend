import Vuex from 'vuex'

import Autolinker from 'autolinker'

export const support = {
  methods: {
    warning_dialog(message_body) {
      this.$buefy.dialog.alert({
        title: "ERROR",
        message: message_body,
        canCancel: ["outside", "escape"],
        type: "is-danger",
        hasIcon: true,
        trapFocus: true,
      })
    },

    ok_notice(message_body, options = {}) {
      this.$buefy.toast.open({message: message_body, position: "is-bottom", queue: false})
      this.say(message_body, options)
    },

    warning_notice(message_body, options = {}) {
      this.sound_play("x")
      this.$buefy.toast.open({message: message_body, position: "is-bottom", type: "is-warning", queue: false})
      this.say(message_body, options)
    },

    say(str, options = {}) {
      this.talk(str, {rate: 1.5, ...options})
    },
  }
}
