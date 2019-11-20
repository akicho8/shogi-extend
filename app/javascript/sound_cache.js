const SOUND_VOLUME = 0.2

import mp3_o     from "oto_logic/Quiz-Correct_Answer02-1.mp3"
import mp3_x     from "oto_logic/Quiz-Wrong_Buzzer02-1.mp3"
import mp3_start from "oto_logic/Quiz-Question03-1.mp3"
import mp3_lose  from "oto_logic/Onmtp-Ding05-1.mp3"
import mp3_win   from "oto_logic/Quiz-Results02-1.mp3"

import { Howl, Howler } from 'howler'

window.sound_objects = {}

export default {
  data() {
    return {
      sound_silent_p: false,

      // sound_objects: {},
      sound_presets: {
        o:     { file: mp3_o,     volume: null, },
        x:     { file: mp3_x,     volume: null, },
        start: { file: mp3_start, volume: null, },
        lose:  { file: mp3_lose,  volume: 0.5,  },
        win:   { file: mp3_win,   volume: 0.5,  },
      },
    }
  },

  methods: {
    sound_play(key, options = {}) {
      if (this.sound_silent_p) {
        return
      }

      const sound_preset = this.sound_presets[key]
      if (sound_preset) {
        options = Object.assign({
          volume: sound_preset.volume || SOUND_VOLUME,
        }, options)
        this.sound_play_by_src(sound_preset.file, options.volume)
      }
    },

    sound_play_by_src(src, volume) {
      if (false) {
        (new Audio(src)).play()
      }

      if (false) {
        new Howl({src: src, autoplay: true, volume: volume})
      }

      if (true) {
        if (!window.sound_objects[src]) {
          window.sound_objects[src] = new Howl({src: src, autoplay: true, volume: volume})
        }
        const obj = window.sound_objects[src]
        obj.stop()
        obj.seek(0)
        obj.play()
      }
    },
  },
}
