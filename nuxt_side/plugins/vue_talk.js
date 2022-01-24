// HOWLER.js
// https://github.com/goldfire/howler.js#documentation

const HOWL_TALK_OPTIONS_DEFAULT = {
  volume: 0.5,
  rate: 1.5,
}

export const vue_talk = {
  methods: {
    // しゃべる
    // ・tab_is_active_p() のときだけ条件を入れてはいけない
    // ・onend に依存して次の処理に繋げている場合もあるためシステムテストが通らなくなるため
    talk(source_text, options = {}) {
      if (process.client) {
        if (source_text != null) {
          if (options.skip_if_tab_is_active_p && this.tab_is_active_p()) {
            // この場合 options.onend を実行しないので注意
            if (this.development_p && options.onend) {
              alert("options.onend がありますがタブがアクティブでないため実行されていません")
            }
          } else {
            const params = {
              source_text: source_text,
            }
            return this.$axios.$post("/api/talk", params, {progress: false}).then(e => {
              if (e.browser_path == null) {
                return Promise.reject("browser_path is blank")
              }
              this.talk_sound_play(e, options)
            })
          }
        }
      }
    },

    // private

    talk_sound_play(e, options = {}) {
      // https://github.com/goldfire/howler.js#documentation
      options = {
        src: e.browser_path,
        ...HOWL_TALK_OPTIONS_DEFAULT,
        ...options,
      }
      return this.howl_auto_play(options)
    },
  },
}
