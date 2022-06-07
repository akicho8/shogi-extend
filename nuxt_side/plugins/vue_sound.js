// import { Howl, Howler } from "howler"
import { SoundPresetInfo } from "@/components/models/sound_preset_info.js"
import _ from "lodash"

export const vue_sound = {
  methods: {
    sound_play(key, options = {}) {
      if (key) {
        const e = SoundPresetInfo.fetch(key)
        options = {
          src: e.source,
          volume: e.volume,
          ...options,
        }
        // https://github.com/goldfire/howler.js#documentation
        return this.howl_auto_play(options)
      }
    },

    sound_play_random(keys, options = {}) {
      return this.sound_play(_.sample(keys), options)
    },

    sound_play_click(options = {}) {
      this.sound_play("click", options)
    },

    sound_play_toggle(enabled, options = {}) {
      let key = null
      if (enabled) {
        key = "toggle_on"
      } else {
        key = "toggle_off"
      }
      this.sound_play(key, options)
    },

    sound_stop_all() {
      if (process.client) {
        Howler.stop()
      }
    },

    // スマホで音が出なくなる問題は unload() で修復できる
    // ただしユーザーに操作させないと反応しない
    // https://github.com/goldfire/howler.js/issues/1526
    // https://github.com/goldfire/howler.js/issues/1525
    sound_resume_all() {
      this.debug_alert("Howler.unload()")
      Howler.unload()
    },

    howl_auto_play(options) {
      options = {
        autoplay: true,
        ...options,
      }
      // https://github.com/goldfire/howler.js#documentation
      return new Howl(options)
    },
  },
}
