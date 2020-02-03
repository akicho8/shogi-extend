window.talk_sound = null

export default {
  methods: {
    wars_tweet_copy_click(swars_tweet_text) {
      this.clipboard_copy({text: swars_tweet_text})
    },

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

      this.silent_http_get_command(js_global.talk_path, {source_text: source_text}, data => {
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
  },

  computed: {
    global_current_user() {
      if (js_global.current_user) {
        return js_global.current_user
      }
    },
  },
}
