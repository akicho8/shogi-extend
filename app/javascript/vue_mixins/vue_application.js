import user_info_show from "../user_info_show.vue"
import tactic_show from "../tactic_show.vue"
import sp_show from "../sp_show.vue"

export default {
  methods: {
    // ログイン強制
    goto_login() {
      if (!js_global.current_user) {
        location.href = js_global.login_path
        return true
      }
    },

    user_info_show_modal(user_key) {
      this.remote_get("/w.json", { query: user_key, format_type: "user", debug: this.$route.query.debug }, data => {
        if (_.isEmpty(data)) {
          this.debug_alert(`${user_key} は存在しません`)
        } else {
          // https://buefy.org/documentation/modal
          this.$buefy.modal.open({
            parent: this,
            props: { info: data },
            hasModalCard: true,
            animation: "",
            fullScreen: true, // this.mobile_p,
            canCancel: ["escape", "outside"],
            trapFocus: true,
            // scroll: "keep",
            // destroyOnHide: false,
            component: user_info_show,
          })
        }
      })
    },

    tactic_show_modal(tactic_key) {
      this.remote_get(`/tactics/${tactic_key}.json`, {}, data => {
        // https://buefy.org/documentation/modal
        this.$buefy.modal.open({
          parent: this,
          props: { record: data },
          hasModalCard: true,
          animation: "",
          fullScreen: false,
          trapFocus: true,
          component: tactic_show,
        })
      })
    },

    sp_show_modal(props) {
      // https://buefy.org/documentation/modal
      this.$buefy.modal.open({
        parent: this,
        props: props,
        hasModalCard: true,
        animation: "",
        fullScreen: true,
        canCancel: ["escape", "outside"],
        trapFocus: true,
        component: sp_show,
      })
    },

    general_ok_notice(message) {
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-dark", queue: false})
      this.talk(message)
    },

    general_ng_notice(message) {
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-danger", queue: false})
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
      })
    },

    bs_error_message_dialog(bs_error) {
      const message = `
          <div>${bs_error.message_prefix}</div>
          <div>${bs_error.message}</div>
          <div class="error_message_pre">${bs_error.board}</div>
        `
      this.error_message_dialog(message)
    },
  },

  computed: {
    global_current_user() {
      if (typeof js_global !== 'undefined') {
        if (js_global.current_user) {
          return js_global.current_user
        }
      }
    },
  },
}
