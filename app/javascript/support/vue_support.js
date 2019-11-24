import Bowser from "bowser"
import dayjs from "dayjs"

window.talk_sound = null

export default {
  methods: {
    rand(n) {
      return Math.floor(Math.random() * n)
    },

    float_to_percentage(v) {
      return Math.floor(v * 100.0)
    },

    process_now() {
      this.$buefy.loading.open()
    },

    js_link_to(href) {
      this.process_now()
      location.href = href
    },

    wars_tweet_copy_click(wars_tweet_body) {
      this.clipboard_copy({text: wars_tweet_body})
    },

    debug_alert(message) {
      if (this.development_p) {
        this.$buefy.toast.open({message: message, position: "is-bottom", type: "is-danger"})
      }
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

    // #以降を除いた現在のパス
    location_url_without_hash() {
      return window.location.href.replace(window.location.hash, "")
    },

    // ?foo=1#xxx を除いた現在のパス
    location_url_without_search_and_hash() {
      return this.location_url_without_hash().replace(window.location.search, "")
    },

    dayjs_format(time, format) {
      return dayjs(time).format(format)
    },
  },

  computed: {
    global_current_user() {
      if (js_global.current_user) {
        return js_global.current_user
      }
    },

    development_p() {
      return process.env.NODE_ENV === "development"
    },

    RAILS_ENV() {
      return window.RAILS_ENV
    },

    // https://www.npmjs.com/package/bowser
    user_agent_hash() {
      console.log(window.navigator.userAgent)
      return Bowser.parse(window.navigator.userAgent)
    },
  },
}
