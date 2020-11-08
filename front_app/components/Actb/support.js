import Vuex from 'vuex'

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

    message_decorate(str) {
      str = this.auto_link(str)
      str = this.simple_format(str)
      str = this.number_replace_to_question_link(str)
      return str
    },

    number_replace_to_question_link(s) {
      return s.replace(/#(\d+)/, '<a href="/actb?question_id=$1">#$1</a>')
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
      return this.$axios.$get("/api/actb.json", {params: {remote_action: command, ...params}}).then(e => block(e))
    },

    silent_api_get(command, params, block) {
      return this.$axios.$get("/api/actb.json", {params: {remote_action: command, ...params}}, {progress: false}).then(e => block(e))
    },

    api_put(command, params, block) {
      return this.$axios.$put("/api/actb.json", {remote_action: command, ...params}).then(e => block(e))
    },

    silent_api_put(command, params, block) {
      return this.$axios.$put("/api/actb.json", {remote_action: command, ...params}, {progress: false}).then(e => block(e))
    },

    ////////////////////////////////////////////////////////////////////////////////

    rating_format(rating) {
      return Math.trunc(rating)
    },

    //////////////////////////////////////////////////////////////////////////////// private

    permit_enable_type(tag) {
      if (this.base.current_user) {
        return this.base.current_user.permit_tag_list.includes(tag)
      }
    },

    permit_hidden_type(tag) {
      if (this.base.current_user) {
        if (this.base.current_user.permit_tag_list.includes(tag)) {
          return false
        }
      }
      return true
    },
  },
  computed: {
    // ...Vuex.mapState([
    //   "base",
    //   "bapp",
    // ]),
    // ...Vuex.mapGetters([
    //   "current_gvar1",
    // ]),
    // // ...mapState([
    // //   "fooKey",
    // // ]),

    permit_staff_p()               { return this.permit_enable_type("staff")                      },
    permit_lobby_message_p()       { return this.permit_hidden_type("lobby_message_hidden")       },
    permit_lobby_message_input_p() { return this.permit_hidden_type("lobby_message_input_hidden") },
    permit_question_new_p()        { return this.permit_hidden_type("question_new_hidden")        },
  },
}
