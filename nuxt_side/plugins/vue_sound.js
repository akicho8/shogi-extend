import { SoundPresetInfo } from "@/components/models/sound_preset_info.js"
import { Howl, Howler } from "howler"
import _ from "lodash"

export const vue_sound = {
  methods: {
    sound_play(key, options = {}) {
      if (key) {
        const e = SoundPresetInfo.fetch(key)
        const params = {
          src: e.source,
          volume: e.volume,
          autoplay: true,
          ...options,
        }
        // https://github.com/goldfire/howler.js#documentation
        return new Howl(params)
      }
    },

    sound_play_random(keys, options = {}) {
      return this.sound_play(_.sample(keys), options)
    },

    sound_play_click(options = {}) {
      this.sound_play("click", options)
    },
  },
}
