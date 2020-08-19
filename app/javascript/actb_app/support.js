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

    ////////////////////////////////////////////////////////////////////////////////

    message_decorate(str) {
      str = this.auto_link(str)
      str = this.simple_format(str)
      str = this.number_replace_to_question_link(str)
      return str
    },

    // ../../../node_modules/autolinker/README.md
    auto_link(str, options = {}) {
      return Autolinker.link(str, {newWindow: true, truncate: 30, mention: "twitter", ...options})
    },

    number_replace_to_question_link(s) {
      return s.replace(/#(\d+)/, '<a href="/training?question_id=$1">#$1</a>')
    },

    ////////////////////////////////////////////////////////////////////////////////

    say(str, options = {}) {
      this.talk(str, {rate: 1.5, ...options})
    },

    login_required_warning_notice() {
      if (!this.app.current_user) {
        this.warning_notice("ログインしてください")
        return true
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    api_get(command, params, block) {
      return this.remote_get(this.app.info.api_path, {remote_action: command, ...params}, block)
    },

    silent_api_get(command, params, block) {
      return this.silent_remote_get(this.app.info.api_path, {remote_action: command, ...params}, block)
    },

    api_put(command, params, block) {
      return this.remote_fetch("PUT", this.app.info.api_path, {remote_action: command, ...params}, block)
    },

    silent_api_put(command, params, block) {
      return this.silent_remote_fetch("PUT", this.app.info.api_path, {remote_action: command, ...params}, block)
    },

    ////////////////////////////////////////////////////////////////////////////////

    rating_format(rating) {
      return Math.trunc(rating)
    },

    //////////////////////////////////////////////////////////////////////////////// private

    permit_enable_type(tag) {
      if (this.app.current_user) {
        return this.app.current_user.permit_tag_list.includes(tag)
      }
    },

    permit_hidden_type(tag) {
      if (this.app.current_user) {
        if (this.app.current_user.permit_tag_list.includes(tag)) {
          return false
        }
      }
      return true
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

    permit_staff_p()               { return this.permit_enable_type("staff")                      },
    permit_lobby_message_p()       { return this.permit_hidden_type("lobby_message_hidden")       },
    permit_lobby_message_input_p() { return this.permit_hidden_type("lobby_message_input_hidden") },
    permit_question_new_p()        { return this.permit_hidden_type("question_new_hidden")        },
  },
}
