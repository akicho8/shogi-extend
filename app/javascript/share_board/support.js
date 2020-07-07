import Vuex from "vuex"

export const support = {
  methods: {
    say(str, options = {}) {
      this.talk(str, {rate: 1.5, ...options})
    },
    ok_notice(message_body, options = {}) {
      this.$buefy.toast.open({message: message_body, position: "is-bottom", type: "is-success", queue: false})
      this.say(message_body, options)
    },
  },
  computed: {
    ...Vuex.mapState([
      "app",
    ]),
  },
}
