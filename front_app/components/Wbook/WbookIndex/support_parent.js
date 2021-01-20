export const support_parent = {
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

    main_nav_set(display_p) {
      return

      const el = document.querySelector("#main_nav")
      if (el) {
        if (display_p) {
          el.classList.remove("is-hidden")
        } else {
          el.classList.add("is-hidden")
        }
      }
    },

    // { xxx: true, yyy: false } 形式に変換
    as_visible_hash(v) {
      return _.reduce(v, (a, e) => ({...a, [e.key]: e.visible}), {})
    },

    ////////////////////////////////////////////////////////////////////////////////

    say(str, options = {}) {
      this.talk(str, {rate: 1.5, ...options})
    },

    login_required_warning_notice() {
      if (!this.base.current_user) {
        this.warning_notice("ログインしてください")
        return true
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    api_get(command, params, block) {
      return this.$axios.$get("/api/wbook.json", {params: {remote_action: command, ...params}}).then(e => block(e))
    },

    silent_api_get(command, params, block) {
      return this.$axios.$get("/api/wbook.json", {params: {remote_action: command, ...params}}, {progress: false}).then(e => block(e))
    },

    api_put(command, params, block) {
      return this.$axios.$put("/api/wbook.json", {remote_action: command, ...params}).then(e => block(e))
    },

    silent_api_put(command, params, block) {
      return this.$axios.$put("/api/wbook.json", {remote_action: command, ...params}, {progress: false}).then(e => block(e))
    },
  },
  computed: {
  },
}
