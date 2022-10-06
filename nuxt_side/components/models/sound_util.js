// window.Howler と window.Howl を定義する
// 他のところで個別に import してはいけない(重要)
import { Howl, Howler } from "howler"
if (process.env.NODE_ENV === "development") {
  console.log("[load] Howler")
}

import { SoundPresetInfo } from "@/components/models/sound_preset_info.js"
import _ from "lodash"

export const SoundUtil = {
  sound_play(key, options = {}) {
    if (key) {
      const e = SoundPresetInfo.fetch(key)
      options = {
        src: e.source,
        volume: e.volume,
        ...options,
      }
      // https://github.com/goldfire/howler.js#documentation
      return this.sound_play_now(options)
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
    Howler.unload()
  },

  // https://github.com/goldfire/howler.js#documentation
  sound_play_now(options) {
    options = {
      autoplay: true,
      ...options,
    }
    if ((new URL(location)).searchParams.get("__system_test_now__")) { // this.$route.query.__system_test_now__
      options.src = require("@/assets/silent.mp3")
    }
    return new Howl(options)
  },
}
