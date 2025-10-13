import { VolumeConfig } from "@/components/models/volume_config.js"
import { GX } from "@/components/models/gs.js"

const MESSAGE_LENGTH_MAX = 140  // N文字を越えるとしゃべらない

const HOWL_DEFAULT_OPTIONS = {
  volume: 0.5,  // 音量
  rate: 1.5,    // 速度
}

export const vue_talk = {
  // ここで定義しはいけない
  // コンポーネント毎の変数ができてしまう
  // data() {
  //   return {
  //     g_talk_volume_scale: scale,
  //   }
  // },

  methods: {
    // 音量スケールを元に戻す
    g_talk_volume_scale_reset() {
      this.g_talk_volume_scale = VolumeConfig.default_scale
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
        if (message.length > MESSAGE_LENGTH_MAX) {
          return
        }
      }
      if (this.__SYSTEM_TEST_RUNNING__) {
        this.sfx_play_now({...options, rate: 2.0, volume: 0, volume_scale: 0})
        return
      }
      const params = {
        source_text: message,
        data: options.data,     // ログに出すため
      }
      return this.$axios.$post("/api/talk", params, {progress: false}).then(e => {
        if (e.browser_path == null) {
          return Promise.reject("browser_path is blank") // ExclusiveAccess::TimeoutError のときここにくる
        }
        this.__talk_core(e, options) // onend にフックできればいいので戻値不要
      })
    },

    // private

    // https://github.com/goldfire/howler.js#documentation
    __talk_core(e, options = {}) {
      this.sfx_play_now({
        ...HOWL_DEFAULT_OPTIONS,
        src: e.browser_path,
        volume_scale: this.g_talk_volume_scale,
        ...options,
      })
    },
  },
}
