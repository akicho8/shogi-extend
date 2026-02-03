import { VolumeCop } from "@/components/models/volume_cop.js"
import { GX } from "@/components/models/gx.js"

const MESSAGE_LENGTH_MAX = 140  // N文字を越えるとしゃべらない

const TALK_DEFAULT_OPTIONS = {
  volume: 0.5,  // 音量
  rate: 1.5,    // 速度
}

export const vue_talk = {
  // ここで定義しはいけない
  // コンポーネント毎の変数ができてしまう
  // data() {
  //   return {
  //     g_volume_talk_user_scale: scale,
  //   }
  // },

  methods: {
    // 音量スケールを元に戻す
    g_volume_talk_user_scale_reset() {
      this.g_volume_talk_user_scale = VolumeCop.CONFIG.user_scale_default
    },

    // しゃべる
    // ・タブが見えているときだけの条件を入れてはいけない
    // ・onend に依存して次の処理に繋げている場合もあるためシステムテストが通らなくなる
    async talk(message, options = {}) {
      message = String(message ?? "")
      if (this.$nuxt.isOffline) {
        return
      }
      if (message === "") {
        return
      }
      if (options.validate_length !== false) {
        if (message.length > MESSAGE_LENGTH_MAX) {
          return
        }
      }
      if (this.__SYSTEM_TEST_RUNNING__) {
        return this.sfx_play_now({...options, rate: 2.0, volume: 0.0, volume_local_user_scale: 0})
      }
      const params = {
        source_text: message,
        data: options.data,     // ログに出すため
      }
      const e = await this.$axios.$post("/api/talk", params, {progress: false})
      if (e.talk_process_skip) {
        console.warn(`テキストを音声に変換することができなかったがエラーとはせず単に await を通過させる : ${message}`)
        return
      }
      return this.__talk_core(e, options)
    },

    // private

    // https://github.com/goldfire/howler.js#documentation
    __talk_core(e, options = {}) {
      return this.sfx_play_now({
        ...TALK_DEFAULT_OPTIONS,
        src: e.browser_path,
        volume_local_user_scale: this.g_volume_talk_user_scale,
        ...options,
      })
    },
  },
}
