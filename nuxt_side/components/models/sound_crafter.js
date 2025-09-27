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

import { Gs } from "@/components/models/gs.js"
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
        __key__: key,
          ...options,
      }
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

    // if (QueryString.parse(location.search)["__system_test_now__"]) {
    //   options.src = require("@/assets/silent.mp3")
    // }

    options.src ??= require("@/assets/silent.mp3")

    // volume_scale によって元のボリュームを調整する
    // volume_scale が 0.5 であれば元のボリュームは変化しない
    // volume_scale が 1.0 で2倍になる
    const old_volume = options.volume
    let scale = null
    const volume_scale = options.volume_scale
    if (volume_scale != null) {
      Gs.assert("number", typeof volume_scale)
      scale = Gs.map_range(volume_scale, 0, 10, 0.0, 2.0)
      options.volume *= scale
    }

    // https://github.com/goldfire/howler.js#documentation
    if (process.env.NODE_ENV === "development") {
      let arg = null
      if (options.__key__) {
        arg = `'${options.__key__}'`
      } else {
        arg = "mp3"
      }
      console.log(`play_now(${arg}) (volume: ${old_volume} -> ${options.volume}, volume_scale: ${options.volume_scale ?? ""}, scale: ${scale ?? ""})`)
    }

    return new Howl(options)
  },

  ////////////////////////////////////////////////////////////////////////////////

  // common_volume_scale: 5,

  common_volume_scale_set(volume) {
    Gs.assert("number", typeof volume)
    if (process.env.NODE_ENV === "development") {
      console.log(`common_volume_scale_set(${volume})`)
    }
    const howler_volume = Gs.map_range(volume, 0, 10, 0.0, 1.0)
    if (process.env.NODE_ENV === "development") {
      console.log(`Howler.volume(${howler_volume})`)
    }
    Howler.volume(howler_volume)
  },

  common_volume_scale_reset() {
    this.common_volume_scale_set(10)
  },
}

SoundCrafter.common_volume_scale_reset()
