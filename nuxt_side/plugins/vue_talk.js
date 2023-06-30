// HOWLER.js
// https://github.com/goldfire/howler.js#documentation

const MESSAGE_LENGTH_MAX = 140

const HOWL_TALK_OPTIONS_DEFAULT = {
  volume: 0.5,   // ~/src/shogi-extend/nuxt_side/components/ShareBoard/models/talk_volume_info.js の音量と合わせる
  rate: 1.5,
}

import { SoundUtil } from "@/components/models/sound_util.js"
import { Gs } from "@/components/models/gs.js"

export const vue_talk = {
  data() {
    return {
      g_talk_volume_rate: HOWL_TALK_OPTIONS_DEFAULT.volume,
    }
  },

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
      if (this.$route.query.__system_test_now__) {
        SoundUtil.play_now({...HOWL_TALK_OPTIONS_DEFAULT, ...options})
        return
      }
      const params = {
        source_text: message,
        data: options.data,     // ログに出すため
      }
      return this.$axios.$post("/api/talk", params, {progress: false}).then(e => {
        if (e.browser_path == null) {
          // ExclusiveAccess::TimeoutError のときここにくる
          return Promise.reject("browser_path is blank")
        }
        this.talk_play(e, options) // onend にフックできればいいので戻値不要
      })
    },

    // 音量を元に戻す
    talk_volume_reset() {
      this.g_talk_volume_rate = HOWL_TALK_OPTIONS_DEFAULT.volume
    },

    // private

    talk_play(e, options = {}) {
      // https://github.com/goldfire/howler.js#documentation
      options = {
        src: e.browser_path,
        ...HOWL_TALK_OPTIONS_DEFAULT,
        volume: this.g_talk_volume_rate,
        ...options,
      }
      Gs.assert(options.volume != null, "options.volume != null")
      SoundUtil.play_now(options) // 戻値不要
    },
  },
}
