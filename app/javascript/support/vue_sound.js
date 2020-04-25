import mp3_o      from "oto_logic/Quiz-Correct_Answer02-1.mp3"
import mp3_x      from "oto_logic/Quiz-Wrong_Buzzer02-1.mp3"
import mp3_start  from "oto_logic/Quiz-Question03-1.mp3"
import mp3_lose   from "oto_logic/Onmtp-Ding05-1.mp3"
import mp3_click  from "oto_logic/Onmtp-Click02-1.mp3"
import mp3_shine  from "air_labo/eye-shine1.mp3"
import mp3_stupid from "air_labo/stupid4.mp3"

import mp3_deden    from "soundeffect_lab/deden.mp3"
import mp3_pipopipo from "soundeffect_lab/pipopipo.mp3"
import mp3_win      from "soundeffect_lab/kansei.mp3"

import { Howl, Howler } from 'howler'

window.HowlObjects = {}

const SoundPresets = {
  o:        { file: mp3_o,        volume: 0.2, },
  x:        { file: mp3_x,        volume: 0.2, },
  start:    { file: mp3_start,    volume: 0.2, },
  lose:     { file: mp3_lose,     volume: 0.5, },
  win:      { file: mp3_win,      volume: 0.5, },
  click:    { file: mp3_click,    volume: 0.2, },
  shine:    { file: mp3_shine,    volume: 0.1, },
  stupid:   { file: mp3_stupid,   volume: 0.5, }, // 使いにくい
  deden:    { file: mp3_deden,    volume: 0.5, },
  pipopipo: { file: mp3_pipopipo, volume: 0.5, },
}

export default {
  data() {
    return {
      sound_silent_p: false,
    }
  },

  methods: {
    sound_play(key, options = {}) {
      if (this.sound_silent_p) {
        return
      }

      const sound_preset = SoundPresets[key]
      if (sound_preset) {
        options = Object.assign({
          volume: sound_preset.volume,
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
        if (!window.HowlObjects[src]) {
          window.HowlObjects[src] = new Howl({src: src, autoplay: true, volume: volume})
        }
        const obj = window.HowlObjects[src]
        obj.stop()
        obj.seek(0)
        obj.play()
      }
    },
  },
}
