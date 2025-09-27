// |----------------------------------------|
// | sfx_play(key, options = {})            |
// | sfx_play_random(keys, options = {})    |
// | sfx_click(options = {})           |
// | sfx_play_toggle(enabled, options = {}) |
// | sfx_stop_all()                         |
// | sfx_resume_all()                       |
// | sfx_play_now(options)                  |
// |----------------------------------------|

// window.Howler と window.Howl を定義する
// 他のところで個別に import してはいけない(重要)
import { Howl, Howler } from "howler"
if (process.env.NODE_ENV === "development") {
  console.log(`[${process.client ? 'CSR' : 'SSR'}][load] Howler`)
}

import { Gs } from "@/components/models/gs.js"
import { SoundPresetInfo } from "@/components/models/sound_preset_info.js"
import { VolumeConfig } from "@/components/models/volume_config.js"
import _ from "lodash"
import QueryString from "query-string"

export const vue_sfx = {
  methods: {
    g_common_volume_scale_reset() {
      this.g_common_volume_scale = VolumeConfig.default_scale
    },

    sfx_play(key, options = {}) {
      if (key) {
        const e = SoundPresetInfo.fetch(key)
        options = {
          src: e.source,
          volume: e.volume,
          __key__: key,
          ...options,
        }
        return this.sfx_play_now(options)
      }
    },

    sfx_play_random(keys, options = {}) {
      return this.sfx_play(_.sample(keys), options)
    },

    sfx_click(options = {}) {
      this.sfx_play("se_click", options)
    },

    sfx_play_toggle(enabled, options = {}) {
      let key = null
      if (enabled) {
        key = "se_toggle_on"
      } else {
        key = "se_toggle_off"
      }
      this.sfx_play(key, options)
    },

    sfx_stop_all() {
      if (process.client) {
        Howler.stop()
      }
    },

    // スマホで音が出なくなる問題は unload() で修復できる
    // ただしユーザーに操作させないと反応しない
    // https://github.com/goldfire/howler.js/issues/1526
    // https://github.com/goldfire/howler.js/issues/1525
    sfx_resume_all() {
      Howler.unload()
    },

    // https://github.com/goldfire/howler.js#documentation
    sfx_play_now(options) {
      options = {
        autoplay: true,
        volume_scale: null,
        ...options,
      }

      options.src ??= require("@/assets/silent.mp3")

      if (options.volume_scale != null) {
        options.volume *= Gs.map_range(options.volume_scale, 0, 10, 0.0, 2.0)
      }
      options.volume *= Gs.map_range(this.g_common_volume_scale, 0, 10, 0.0, 2.0)

      return new Howl(options)
    },
  },
}
