window.howl_object = null

export default {
  methods: {
    tab_is_active_p() {
      return !this.tab_is_active_p()
    },

    tab_is_hidden_p() {
      // console.log("[hidden, visibilityState]", [document.hidden, document.visibilityState])
      return document.hidden || document.visibilityState === "hidden"
    },

    talk_stop() {
      if (window.howl_object) {
        window.howl_object.stop()
        window.howl_object = null
      }
    },

    // しゃべる
    talk(source_text, options = {}) {
      if (!this.tab_is_hidden_p()) {
        const params = {
          source_text: source_text,
          full_url: "true",
        }
        // return this.$axios.request({method: "get", url: "/api/talk", params: params}).then(({data}) => this.mp3_talk(data, options))
        // return this.$axios.get("/api/talk", {params: params}).then(({data}) => this.mp3_talk(data, options))
        return this.$axios.post("/api/talk", params, {progress: false}).then(({data}) => this.mp3_talk(data, options))
      }
    },

    // private

    mp3_talk(data, options = {}) {
      options = {
        talk_method: "howler",
        ...options,
      }

      // すぐに発声する場合
      if (options.talk_method === "direct_audio") {
        const audio = new Audio()
        audio.src = data.mp3_path
        audio.play()
      }

      // 最後に来た音声のみ発声(?)
      if (false) {
        if (!audio) {
          audio = new Audio()
        }
        audio.src = data.mp3_path
        audio.play()
      }

      // FIFO形式で順次発声
      if (options.talk_method === "queue") {
        audio_queue.media_push(data.mp3_path)
      }

      // Howler
      if (options.talk_method === "howler") {
        window.howl_object = new Howl({
          src: data.mp3_path,
          autoplay: true,
          volume: options.volume || 1.0,
          rate: options.rate || 1.2,
        })
        if (options.onend) {
          window.howl_object.on("end", () => options.onend())
        }
      }
    },
  },
}
