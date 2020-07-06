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
        icon: "times-circle",
        iconPack: "fa",
        trapFocus: true,
      })
    },

    ok_notice(message_body, options = {}) {
      this.$buefy.toast.open({message: message_body, position: "is-bottom", type: "is-success", queue: false})
      this.say(message_body, options)
    },

    warning_notice(message_body) {
      this.sound_play("x")
      this.$buefy.toast.open({message: message_body, position: "is-bottom", type: "is-warning", queue: false})
      this.say(message_body)
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

    delay(seconds, block) {
      return setTimeout(block, 1000 * seconds)
    },

    delay_stop(delay_id) {
      if (delay_id) {
        clearTimeout(delay_id)
      }
    },

    // { xxx: true, yyy: false } 形式に変換
    as_visible_hash(v) {
      return _.reduce(v, (a, e) => ({...a, [e.key]: e.visible}), {})
    },

    // ../../../node_modules/autolinker/README.md
    auto_link(str, options = {}) {
      return Autolinker.link(str, {newWindow: true, truncate: 30, mention: "twitter", ...options})
    },

    say(str, options = {}) {
      this.talk(str, {rate: 1.5, ...options})
    },

    login_required_warning_notice() {
      if (!this.app.current_user) {
        this.warning_notice("ログインしてください")
        return true
      }
    },
  },
  computed: {
    ...Vuex.mapState([
      'app',
    ]),
    ...Vuex.mapGetters([
      'current_gvar1',
    ]),
    // ...mapState([
    //   'fooKey',
    // ]),

    staff_only() {
      if (this.app.current_user) {
        return this.app.current_user.permit_tag_list.includes("staff")
      }
    },
  },
}
