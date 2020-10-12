import mp3_o             from "../static/sound_effect/oto_logic/Quiz-Correct_Answer02-1.mp3"
import mp3_x             from "../static/sound_effect/oto_logic/Quiz-Wrong_Buzzer02-1.mp3"
import mp3_start         from "../static/sound_effect/oto_logic/Quiz-Question03-1.mp3"
import mp3_lose          from "../static/sound_effect/oto_logic/Onmtp-Ding05-1.mp3"
// import mp3_click         from "../static/sound_effect/oto_logic/Onmtp-Click02-1.mp3"
// import mp3_click         from "../../../UnitySoundApp/Assets/Universal Sound FX/8BIT/Beeps/8BIT_RETRO_Beep_Smooth_Sine_Deep_mono.wav"
import mp3_click         from "../../../UnitySoundApp/Assets/Universal Sound FX/BUTTONS/BUTTON_Light_Switch_03_stereo.wav"
// import mp3_click         from "../../../UnitySoundApp/Assets/Universal Sound FX/USER_INTERFACES/Beeps/UI_Beep_Double_Clean_Up_stereo.wav"
// Assets/Universal Sound FX/USER_INTERFACES/Beeps/UI_Beep_Double_Quick_Smooth_stereo.wav

import mp3_spon          from "../static/sound_effect/oto_logic/Onmtp-Pop01-4.mp3"

import mp3_notify        from "../static/sound_effect/soundeffect_lab/decision29.mp3"

// import mp3_poon          from "../static/sound_effect/niconicommons/nc141655.mp3"
import mp3_poon          from "../../../UnitySoundApp/Assets/Universal Sound FX/PUZZLES/PUZZLE_Success_Bright_Voice_Two_Note_Fast_Delay_stereo.wav"

import mp3_deden         from "../static/sound_effect/soundeffect_lab/deden.mp3"
import mp3_pipopipo      from "../static/sound_effect/soundeffect_lab/pipopipo.mp3"
import mp3_win           from "../static/sound_effect/soundeffect_lab/kansei.mp3"
import mp3_bubuu         from "../static/sound_effect/soundeffect_lab/bubuu.mp3"
import mp3_draw          from "../static/sound_effect/soundeffect_lab/stupid5.mp3"
import mp3_new_challenge from "../static/sound_effect/soundeffect_lab/decision5.mp3"
import mp3_bell2         from "../static/sound_effect/soundeffect_lab/decision26.mp3"

// import wav_pon           from "../static/sound_effect/soundeffect_lab/kotsudumi1.mp3"
import wav_pon           from "../../../UnitySoundApp/Assets/Universal Sound FX/CARTOON/POP_Mouth_mono.wav"

import wav_piece_sound    from "shogi-player/src/assets/Universal_Sound_FX/TABLE_TENNIS_Racket_Ball_Hit_07_Hard_mono.wav"

import { Howl, Howler } from 'howler'

window.HowlObjects = {}

const SoundPresets = {
  o:             { file: mp3_o,             volume: 0.2,  },
  x:             { file: mp3_x,             volume: 0.2,  },
  start:         { file: mp3_start,         volume: 0.2,  },
  lose:          { file: mp3_lose,          volume: 0.3,  },
  win:           { file: mp3_win,           volume: 0.15, },
  click:         { file: mp3_click,         volume: 0.7,  },
  poon:          { file: mp3_poon,          volume: 0.05, },
  deden:         { file: mp3_deden,         volume: 0.08, },
  pipopipo:      { file: mp3_pipopipo,      volume: 0.5,  },
  piece_sound:   { file: wav_piece_sound,   volume: 0.25, },
  correct:       { file: mp3_o,             volume: 0.2,  },
  mistake:       { file: mp3_x,             volume: 0.2,  },
  timeout:       { file: mp3_bubuu,         volume: 0.2,  },
  draw:          { file: mp3_draw,          volume: 0.3,  },
  new_challenge: { file: mp3_new_challenge, volume: 0.3,  },
  bell2:         { file: mp3_bell2,         volume: 0.3,  },
  pon:           { file: wav_pon,           volume: 0.5,  },
  notify:        { file: mp3_notify,        volume: 0.5,  },
  spon:          { file: mp3_spon,          volume: 0.7,  },
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
