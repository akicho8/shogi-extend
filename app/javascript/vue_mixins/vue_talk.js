window.talk_sound = null

export default {
  methods: {
    tab_is_active_p() {
      console.log("document.hidden", document.hidden)
      console.log("document.visibilityState", document.visibilityState)
      return !(document.hidden || document.visibilityState === "hidden")
    },

    talk_stop() {
      if (window.talk_sound) {
        window.talk_sound.stop()
        window.talk_sound = null
      }
    },

    // しゃべる
    talk(source_text, options = {}) {
      if (!this.tab_is_active_p()) {
        return
      }

      options = {talk_method: "howler", ...options}

      this.silent_remote_get("/talk", {source_text: source_text}, data => {
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
          window.talk_sound = new Howl({
            src: data.mp3_path,
            autoplay: true,
            volume: options.volume || 1.0,
            rate: options.rate || 1.2,
          })
          if (options.onend) {
            window.talk_sound.on("end", () => options.onend())
          }
        }
      })
    },
  },
}
