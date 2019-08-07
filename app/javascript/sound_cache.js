const SOUND_VOLUME = 0.2

import mp3_o     from "oto_logic/Quiz-Correct_Answer02-1.mp3"
import mp3_x     from "oto_logic/Quiz-Wrong_Buzzer02-1.mp3"
import mp3_start from "oto_logic/Quiz-Question03-1.mp3"

import { Howl, Howler } from 'howler'

window.sound_objects = {}

export default {
  data() {
    return {
      // sound_objects: {},
      sound_presets: {
        o:     { file: mp3_o,     volume: null, },
        x:     { file: mp3_x,     volume: null, },
        start: { file: mp3_start, volume: null, },
      },
    }
  },

  methods: {
    sound_play(key) {
      const sound_preset = this.sound_presets[key]
      if (sound_preset) {
        this.sound_play_by_src(sound_preset.file)
      }
    },

    sound_play_by_src(src, volume = SOUND_VOLUME) {
      if (false) {
        (new Audio(src)).play()
      }

      if (false) {
        new Howl({src: src, autoplay: true, volume: SOUND_VOLUME})
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
