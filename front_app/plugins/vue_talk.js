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
    // ・tab_is_active_p() のときだけ条件を入れてはいけない
    // ・onend に依存して次の処理に繋げている場合もあるためシステムテストが通らなくなる
    talk(source_text, options = {}) {
      if (process.client) {
        if (source_text != null) {
          if (options.skip_if_tab_is_active_p && this.tab_is_active_p()) {
            // この場合 options.onend を実行しないので注意
            if (this.development_p && options.onend) {
              alert("options.onend がありますがタブがアクティブでないため実行されていません")
            }
          } else {
            // if (this.tab_is_active_p() && source_text) {
            const params = {
              source_text: source_text,
            }
            // return this.$axios.request({method: "get", url: "/api/talk", params: params}).then(({data}) => this.mp3_talk(data, options))
            // return this.$axios.get("/api/talk", {params: params}).then(({data}) => this.mp3_talk(data, options))
            return this.$axios.$post("/api/talk", params, {progress: false}).then(e => {
              if (e.browser_path == null) {
                return Promise.reject("browser_path is blank")
              } else {
                this.mp3_talk(e, options)
              }
            })
          }
        }
      }
    },

    // private

    mp3_talk(data, options = {}) {
      window.howl_object = new Howl({
        src: data.browser_path,
        autoplay: true,
        volume: options.volume || 1.0,
        rate: options.rate || 1.5,
      })
      if (options.onend) {
        window.howl_object.on("end", () => options.onend())
      }
    },
  },
}
