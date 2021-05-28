import MemoryRecord from 'js-memory-record'

export class SoundPreset extends MemoryRecord {
  static get define() {
    return [
      { key: "o",              source: require("@/static/sound_effect/oto_logic/Quiz-Correct_Answer02-1.mp3"),                                  volume: 0.20, },
      { key: "x",              source: require("@/static/sound_effect/oto_logic/Quiz-Wrong_Buzzer02-1.mp3"),                                    volume: 0.20, },
      { key: "start",          source: require("@/static/sound_effect/oto_logic/Quiz-Question03-1.mp3"),                                        volume: 0.15, },
      { key: "lose",           source: require("@/static/sound_effect/oto_logic/Onmtp-Ding05-1.mp3"),                                           volume: 0.30, },
      { key: "win",            source: require("@/static/sound_effect/soundeffect_lab/kansei.mp3"),                                             volume: 0.20, },
      { key: "click",          source: require("@/assets/UniversalSoundFX/USER_INTERFACES/Beeps/UI_Beep_Double_Quick_Smooth_stereo.wav"),       volume: 0.50, },
      { key: "poon",           source: require("@/assets/UniversalSoundFX/PUZZLES/PUZZLE_Success_Bright_Voice_Two_Note_Fast_Delay_stereo.wav"), volume: 0.10, },
      { key: "bird",           source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Bird_Crow_01_mono.wav"),                               volume: 0.50, },
      { key: "rooster",        source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Rooster_Crow_01_mono.wav"),                            volume: 0.30, },
      { key: "moo1",           source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Cow_Moo_01_mono.wav"),                                 volume: 0.50, },
      { key: "moo2",           source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Cow_Moo_02_mono.wav"),                                 volume: 0.50, },
      { key: "moo3",           source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Cow_Moo_03_mono.wav"),                                 volume: 0.50, },
      { key: "door_open",      source: require("@/assets/UniversalSoundFX/DOORS_GATES_DRAWERS/DOOR_Indoor_Wood_Open_stereo.wav"),               volume: 0.80, },
      { key: "door_close",     source: require("@/assets/UniversalSoundFX/DOORS_GATES_DRAWERS/DOOR_Indoor_Wood_Close_stereo.wav"),              volume: 0.80, },
      { key: "deden",          source: require("@/static/sound_effect/soundeffect_lab/deden.mp3"),                                              volume: 0.20, },
      { key: "pipopipo",       source: require("@/static/sound_effect/soundeffect_lab/pipopipo.mp3"),                                           volume: 0.20, },
      { key: "correct",        source: require("@/static/sound_effect/oto_logic/Quiz-Correct_Answer02-1.mp3"),                                  volume: 0.20, },
      { key: "mistake",        source: require("@/static/sound_effect/oto_logic/Quiz-Wrong_Buzzer02-1.mp3"),                                    volume: 0.20, },
      { key: "timeout",        source: require("@/static/sound_effect/soundeffect_lab/bubuu.mp3"),                                              volume: 0.20, },
      { key: "draw",           source: require("@/static/sound_effect/soundeffect_lab/stupid5.mp3"),                                            volume: 0.20, },
      { key: "new_challenge",  source: require("@/static/sound_effect/soundeffect_lab/decision5.mp3"),                                          volume: 0.30, },
      { key: "notify",         source: require("@/static/sound_effect/soundeffect_lab/decision29.mp3"),                                         volume: 0.30, },
      { key: "spon",           source: require("@/static/sound_effect/oto_logic/Onmtp-Pop01-4.mp3"),                                            volume: 0.50, },
      { key: "pon",            source: require("@/assets/UniversalSoundFX/CARTOON/POP_Mouth_mono.wav"),                                         volume: 0.40, },
      { key: "piece_sound",    source: require("shogi-player/assets/Universal_Sound_FX/TABLE_TENNIS_Racket_Ball_Hit_07_Hard_mono.wav"),         volume: 0.20, },
    ]
  }
}
