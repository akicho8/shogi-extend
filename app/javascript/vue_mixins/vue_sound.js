import mp3_o        from "../sound_effect/oto_logic/Quiz-Correct_Answer02-1.mp3"
import mp3_x        from "../sound_effect/oto_logic/Quiz-Wrong_Buzzer02-1.mp3"
import mp3_start    from "../sound_effect/oto_logic/Quiz-Question03-1.mp3"
import mp3_lose     from "../sound_effect/oto_logic/Onmtp-Ding05-1.mp3"
import mp3_click    from "../sound_effect/oto_logic/Onmtp-Click02-1.mp3"
import mp3_spon     from "../sound_effect/oto_logic/Onmtp-Pop01-4.mp3"

import mp3_shine    from "../sound_effect/air_labo/eye-shine1.mp3"
import mp3_stupid   from "../sound_effect/air_labo/stupid4.mp3"
import mp3_notify   from "../sound_effect/soundeffect_lab/decision29.mp3"

import mp3_poon     from "../sound_effect/niconicommons/nc141655.mp3"
import mp3_deden    from "../sound_effect/soundeffect_lab/deden.mp3"
import mp3_pipopipo from "../sound_effect/soundeffect_lab/pipopipo.mp3"
import mp3_win      from "../sound_effect/soundeffect_lab/kansei.mp3"
import mp3_bubuu    from "../sound_effect/soundeffect_lab/bubuu.mp3"
import mp3_draw     from "../sound_effect/soundeffect_lab/stupid5.mp3"
import mp3_new_challenge    from "../sound_effect/soundeffect_lab/decision5.mp3"
import mp3_bell2    from "../sound_effect/soundeffect_lab/decision26.mp3"
import mp3_pon      from "../sound_effect/soundeffect_lab/kotsudumi1.mp3"

import wav_pishi    from "../../../node_modules/shogi-player/src/assets/piece_sound.wav"

import { Howl, Howler } from 'howler'

window.HowlObjects = {}

const SoundPresets = {
  o:        { file: mp3_o,        volume: 0.2,  },
  x:        { file: mp3_x,        volume: 0.2,  },
  start:    { file: mp3_start,    volume: 0.2,  },
  lose:     { file: mp3_lose,     volume: 0.3,  },
  win:      { file: mp3_win,      volume: 0.15, },
  click:    { file: mp3_click,    volume: 0.2,  },
  shine:    { file: mp3_shine,    volume: 0.1,  },
  stupid:   { file: mp3_stupid,   volume: 0.5,  }, // 使いにくい
  poon:     { file: mp3_poon,     volume: 0.05, },
  deden:    { file: mp3_deden,    volume: 0.08, },
  pipopipo: { file: mp3_pipopipo, volume: 0.5,  },
  pishi:    { file: wav_pishi,    volume: 0.3,  },
  correct:  { file: mp3_o,        volume: 0.2,  },
  mistake:  { file: mp3_x,        volume: 0.2,  },
  timeout:  { file: mp3_bubuu,    volume: 0.2,  },
  draw:     { file: mp3_draw,     volume: 0.3,  },
  new_challenge:    { file: mp3_new_challenge,    volume: 0.3,  },
  bell2:    { file: mp3_bell2,    volume: 0.3,  },
  pon:      { file: mp3_pon,      volume: 0.5,  },
  notify:   { file: mp3_notify,   volume: 0.5,  },
  spon:     { file: mp3_spon,     volume: 0.7,  },
}

export default {
  data() {
    return {
      sound_silent_p: false,
    }
  },

  methods: {
    // options に $event が渡されないように引数は受けとらない
    click_play() {
      this.sound_play("click")
    },

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
