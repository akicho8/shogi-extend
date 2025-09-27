// HOWLER.js
// https://github.com/goldfire/howler.js#documentation

import { VueTalkConfig } from "@/plugins/vue_talk_config.js"
import { SoundCrafter } from "@/components/models/sound_crafter.js"
import { Gs } from "@/components/models/gs.js"

export const vue_talk = {
  // ここで定義してしまうと各コンポーネント毎の g_talk_volume_scale が存在してしまいグローバルでなくなる
  // data() {
  //   return {
  //     g_talk_volume_scale: VOLUME_SCALE,
  //   }
  // },

  methods: {
    // 音量スケールを元に戻す
    g_talk_volume_scale_reset() {
      this.g_talk_volume_scale = VueTalkConfig.VOLUME_SCALE
    },

    // しゃべる
    // ・タブが見えているときだけの条件を入れてはいけない
    // ・onend に依存して次の処理に繋げている場合もあるためシステムテストが通らなくなる
    talk(message, options = {}) {
      message = String(message ?? "")
      if (message === "") {
        return
      }
      if (options.validate_length !== false) {
        if (message.length > VueTalkConfig.MESSAGE_LENGTH_MAX) {
          return
        }
      }
      if (this.$route.query.__system_test_now__) {
        options = {
          rate: VueTalkConfig.RATE,
          volume: VueTalkConfig.VOLUME_BASE,
          volume_scale: this.g_talk_volume_scale,
          ...options,
        }
        SoundCrafter.play_now(options)
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

    // private

    talk_play(e, options = {}) {
      // https://github.com/goldfire/howler.js#documentation
      options = {
        src: e.browser_path,
        rate: VueTalkConfig.RATE,
        volume: VueTalkConfig.VOLUME_BASE,
        volume_scale: this.g_talk_volume_scale,
        ...options,
      }
      console.log("talk_play")
      console.log(options)
      Gs.assert(options.volume != null, "options.volume != null")
      SoundCrafter.play_now(options) // 戻値不要
    },
  },
}
