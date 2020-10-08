import { mapState, mapMutations, mapActions } from "vuex"

export default {
  methods: {
    general_ok_notice(message, options = {}) {
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-dark", queue: false, ...options})
      this.talk(message)
    },

    general_ng_notice(message, options = {}) {
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-danger", queue: false, ...options})
      this.talk(message)
    },

    error_message_dialog(message) {
      this.$buefy.dialog.alert({
        title: "ERROR",
        message: message,
        canCancel: ["outside", "escape"],
        type: "is-danger",
        hasIcon: true,
        trapFocus: true,
        onConfirm: () => { this.sound_play("click") },
        onCancel:  () => { this.sound_play("click") },
      })
    },

    bs_error_message_dialog(bs_error) {
      const message = `
          <div>${bs_error.message_prefix}</div>
          <div>${bs_error.message}</div>
          <div class="error_message_pre mt-2 has-background-white-ter box is-shadowless">${bs_error.board}</div>
        `
      this.sound_play("x")
      this.error_message_dialog(message)
    },
  },

  computed: {
    ...mapState("user", [
      "g_current_user",
    ]),
  },
}
