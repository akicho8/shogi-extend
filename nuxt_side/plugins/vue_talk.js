// HOWLER.js
// https://github.com/goldfire/howler.js#documentation

const MESSAGE_LENGTH_MAX = 140

const HOWL_TALK_OPTIONS_DEFAULT = {
  volume: 0.5,
  rate: 1.5,
}

import { SoundUtil } from "@/components/models/sound_util.js"
import { Gs2 } from "@/components/models/gs2.js"

export const vue_talk = {
  methods: {
    // しゃべる
    // ・タブが見えているときだけの条件を入れてはいけない
    // ・onend に依存して次の処理に繋げている場合もあるためシステムテストが通らなくなる
    talk(message, options = {}) {
      message = String(message ?? "")
      if (message === "") {
        return
      }
      if (options.validate_length !== false) {
        if (message.length > MESSAGE_LENGTH_MAX) {
          return
        }
      }
      const params = {
        source_text: message,
      }
      if (this.$route.query.__system_test_now__) {
        SoundUtil.sound_play_now({...HOWL_TALK_OPTIONS_DEFAULT, ...options})
        return
      }
      return this.$axios.$post("/api/talk", params, {progress: false}).then(e => {
        if (e.browser_path == null) {
          return Promise.reject("browser_path is blank")
        }
        this.talk_sound_play(e, options) // onend にフックできればいいので戻値不要
      })
    },

    // private

    talk_sound_play(e, options = {}) {
      // https://github.com/goldfire/howler.js#documentation
      options = {
        src: e.browser_path,
        ...HOWL_TALK_OPTIONS_DEFAULT,
        ...options,
      }
      SoundUtil.sound_play_now(options) // 戻値不要
    },
  },
}
