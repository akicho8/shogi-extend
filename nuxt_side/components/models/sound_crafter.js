// |------------------------------------|
// | play(key, options = {})            |
// | play_random(keys, options = {})    |
// | play_click(options = {})           |
// | play_toggle(enabled, options = {}) |
// | stop_all()                         |
// | resume_all()                       |
// | play_now(options)                  |
// |------------------------------------|

// window.Howler と window.Howl を定義する
// 他のところで個別に import してはいけない(重要)
import { Howl, Howler } from "howler"
if (process.env.NODE_ENV === "development") {
  console.log(`[${process.client ? 'CSR' : 'SSR'}][load] Howler `)
}

import { SoundPresetInfo } from "@/components/models/sound_preset_info.js"
import _ from "lodash"
import QueryString from "query-string"

export const SoundCrafter = {
  play(key, options = {}) {
    if (key) {
      const e = SoundPresetInfo.fetch(key)
      options = {
        src: e.source,
        volume: e.volume,
        ...options,
      }
      // https://github.com/goldfire/howler.js#documentation
      return this.play_now(options)
    }
  },

  play_random(keys, options = {}) {
    return this.play(_.sample(keys), options)
  },

  play_click(options = {}) {
    this.play("se_click", options)
  },

  play_toggle(enabled, options = {}) {
    let key = null
    if (enabled) {
      key = "se_toggle_on"
    } else {
      key = "se_toggle_off"
    }
    this.play(key, options)
  },

  stop_all() {
    if (process.client) {
      Howler.stop()
    }
  },

  // スマホで音が出なくなる問題は unload() で修復できる
  // ただしユーザーに操作させないと反応しない
  // https://github.com/goldfire/howler.js/issues/1526
  // https://github.com/goldfire/howler.js/issues/1525
  resume_all() {
    Howler.unload()
  },

  // https://github.com/goldfire/howler.js#documentation
  play_now(options) {
    options = {
      autoplay: true,
      ...options,
    }
    if (QueryString.parse(location.search)["__system_test_now__"]) {
      options.src = require("@/assets/silent.mp3")
    }
    return new Howl(options)
  },
}
