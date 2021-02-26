if (process.client) {
  window.howl_object = null
}

export default {
  methods: {
    talk_stop() {
      if (process.client) {
        if (window.howl_object) {
          window.howl_object.stop()
          window.howl_object = null
        }
      }
    },

    // しゃべる
    talk(source_text, options = {}) {
      if (process.client) {
        if (this.tab_is_active_p() && source_text) {
          const params = {
            source_text: source_text,
          }
          // return this.$axios.request({method: "get", url: "/api/talk", params: params}).then(({data}) => this.mp3_talk(data, options))
          // return this.$axios.get("/api/talk", {params: params}).then(({data}) => this.mp3_talk(data, options))
          return this.$axios.$post("/api/talk", params, {progress: false}).then(e => {
            if (e.mp3_path == null) {
              return Promise.reject("mp3_path is blank")
            } else {
              this.mp3_talk(e, options)
            }
          })
        }
      }
    },

    // private

    mp3_talk(data, options = {}) {
      window.howl_object = new Howl({
        src: data.mp3_path,
        autoplay: true,
        volume: options.volume || 1.0,
        rate: options.rate || 1.65,
      })
      if (options.onend) {
        window.howl_object.on("end", () => options.onend())
      }
    },
  },
}
