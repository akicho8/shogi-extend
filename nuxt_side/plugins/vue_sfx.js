// |----------------------------------------|
// | sfx_play(key, options = {})            |
// | sfx_play_random(keys, options = {})    |
// | sfx_click(options = {})                |
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

import { GX } from "@/components/models/gx.js"
import { SfxPresetInfo } from "@/components/models/sfx_preset_info.js"
import { VolumeCop } from "@/components/models/volume_cop.js"
import _ from "lodash"
import QueryString from "query-string"

export const vue_sfx = {
  methods: {
    g_volume_common_user_scale_reset() {
      this.g_volume_common_user_scale = VolumeCop.CONFIG.user_scale_default
    },

    sfx_play(key, options = {}) {
      if (key) {
        const e = SfxPresetInfo.fetch(key)
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
      return this.sfx_play("se_click", options)
    },

    sfx_play_toggle(enabled, options = {}) {
      let key = null
      if (enabled) {
        key = "se_toggle_on"
      } else {
        key = "se_toggle_off"
      }
      return this.sfx_play(key, options)
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
        volume_local_user_scale: null,
        ...options,
      }

      options.src ??= require("@/assets/sfx/no_sound.mp3")

      let volume = options.volume
      volume = VolumeCop.volume_convert(volume, options.volume_local_user_scale)
      volume = VolumeCop.volume_convert(volume, this.g_volume_common_user_scale)
      // this.sfx_log("sfx_play_now", options.src, options.volume)

      return new Promise((resolve, reject) => {
        const sound = new Howl({
          ...options,
          volume: volume,
          onend: () => resolve(),
          onloaderror: (_, msg) => reject(msg),
          onplayerror: (_, msg) => reject(msg),
        })
      })
    },

    // sfx_log(...args) {
    //   if (process.env.NODE_ENV === "development") {
    //     console.log("[sfx_log]", ...args)
    //   }
    // },
  },
}
