import mp3_o             from "@/static/sound_effect/oto_logic/Quiz-Correct_Answer02-1.mp3"
import mp3_x             from "@/static/sound_effect/oto_logic/Quiz-Wrong_Buzzer02-1.mp3"
import mp3_start         from "@/static/sound_effect/oto_logic/Quiz-Question03-1.mp3"
import mp3_lose          from "@/static/sound_effect/oto_logic/Onmtp-Ding05-1.mp3"
import mp3_click         from "@/assets/UniversalSoundFX/USER_INTERFACES/Beeps/UI_Beep_Double_Quick_Deep_Muffled_stereo.wav"
import mp3_spon          from "@/static/sound_effect/oto_logic/Onmtp-Pop01-4.mp3"
import mp3_notify        from "@/static/sound_effect/soundeffect_lab/decision29.mp3"
import mp3_poon          from "@/assets/UniversalSoundFX/PUZZLES/PUZZLE_Success_Bright_Voice_Two_Note_Fast_Delay_stereo.wav"
import mp3_deden         from "@/static/sound_effect/soundeffect_lab/deden.mp3"
import mp3_pipopipo      from "@/static/sound_effect/soundeffect_lab/pipopipo.mp3"
import mp3_win           from "@/static/sound_effect/soundeffect_lab/kansei.mp3"
import mp3_bubuu         from "@/static/sound_effect/soundeffect_lab/bubuu.mp3"
import mp3_draw          from "@/static/sound_effect/soundeffect_lab/stupid5.mp3"
import mp3_new_challenge from "@/static/sound_effect/soundeffect_lab/decision5.mp3"
import wav_pon           from "@/assets/UniversalSoundFX/CARTOON/POP_Mouth_mono.wav"
import wav_piece_sound   from "shogi-player/assets/Universal_Sound_FX/TABLE_TENNIS_Racket_Ball_Hit_07_Hard_mono.wav"

import MemoryRecord from 'js-memory-record'

export class SoundPreset extends MemoryRecord {
  static get define() {
    return [
      { key: "o",              source: mp3_o,             volume: 0.20, },
      { key: "x",              source: mp3_x,             volume: 0.20, },
      { key: "start",          source: mp3_start,         volume: 0.20, },
      { key: "lose",           source: mp3_lose,          volume: 0.30, },
      { key: "win",            source: mp3_win,           volume: 0.20, },
      { key: "click",          source: mp3_click,         volume: 0.60, },
      { key: "poon",           source: mp3_poon,          volume: 0.10, },
      { key: "deden",          source: mp3_deden,         volume: 0.20, },
      { key: "pipopipo",       source: mp3_pipopipo,      volume: 0.20, },
      { key: "correct",        source: mp3_o,             volume: 0.20, },
      { key: "mistake",        source: mp3_x,             volume: 0.20, },
      { key: "timeout",        source: mp3_bubuu,         volume: 0.20, },
      { key: "draw",           source: mp3_draw,          volume: 0.20, },
      { key: "new_challenge",  source: mp3_new_challenge, volume: 0.30, },
      { key: "notify",         source: mp3_notify,        volume: 0.30, },
      { key: "spon",           source: mp3_spon,          volume: 0.50, },
      { key: "pon",            source: wav_pon,           volume: 0.50, },
      { key: "piece_sound",    source: wav_piece_sound,   volume: 0.20, },
    ]
  }
}
