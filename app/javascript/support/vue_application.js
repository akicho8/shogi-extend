window.talk_sound = null

import user_info_show from "../user_info_show.vue"
import tactic_show from "../tactic_show.vue"
import sp_show from "../sp_show.vue"

export default {
  methods: {
    // ログイン強制
    login_required() {
      if (!js_global.current_user) {
        location.href = js_global.login_path
        return true
      }
    },

    // しゃべる
    talk(source_text, options = {}) {
      if (!tab_is_active_p()) {
        return
      }

      options = {talk_method: "howler", ...options}

      this.silent_remote_get(js_global.talk_path, {source_text: source_text}, data => {
        // すぐに発声する場合
        if (options.talk_method === "direct_audio") {
          const audio = new Audio()
          audio.src = data.service_path
          audio.play()
        }

        // 最後に来た音声のみ発声(?)
        if (false) {
          if (!audio) {
            audio = new Audio()
          }
          audio.src = data.service_path
          audio.play()
        }

        // FIFO形式で順次発声
        if (options.talk_method === "queue") {
          audio_queue.media_push(data.service_path)
        }

        // Howler
        if (options.talk_method === "howler") {
          window.talk_sound = new Howl({src: data.service_path, autoplay: true, volume: options.volume || 1.0, rate: options.rate || 1.2})
          if (options.onend) {
            window.talk_sound.on("end", () => options.onend())
          }
        }
      })
    },

    talk_stop() {
      if (window.talk_sound) {
        window.talk_sound.stop()
        window.talk_sound = null
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
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-primary"})
      this.talk(message, {rate: 1.5})
    },

    general_warning_notice(message) {
      this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-danger"})
      this.talk(message, {rate: 1.5})
    },

    error_message_dialog(message) {
      this.$buefy.dialog.alert({
        title: "ERROR",
        message: message,
        canCancel: ["outside", "escape"],
        type: "is-danger",
        hasIcon: true,
        icon: "times-circle",
        iconPack: "fa",
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
      if (js_global.current_user) {
        return js_global.current_user
      }
    },
  },
}
