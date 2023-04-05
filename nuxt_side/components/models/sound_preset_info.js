import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SoundPresetInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "o",                                    source: require("@/static/sound_effect/oto_logic/Quiz-Correct_Answer02-1.mp3"),                                  volume: 0.20, },
      { key: "x",                                    source: require("@/static/sound_effect/oto_logic/Quiz-Wrong_Buzzer02-1.mp3"),                                    volume: 0.20, },
      { key: "start",                                source: require("@/static/sound_effect/oto_logic/Quiz-Question03-1.mp3"),                                        volume: 0.15, },
      { key: "lose",                                 source: require("@/static/sound_effect/oto_logic/Onmtp-Ding05-1.mp3"),                                           volume: 0.30, },
      { key: "win",                                  source: require("@/static/sound_effect/soundeffect_lab/kansei.mp3"),                                             volume: 0.20, },

      // { key: "click",                                source: require("@/assets/UniversalSoundFX/USER_INTERFACES/Beeps/UI_Beep_Double_Quick_Smooth_stereo.wav"),       volume: 0.40, },
      { key: "click",                                source: require("@/assets/SND01_sine/tap_03.wav"),       volume: 0.40, },
      { key: "toggle_on",                            source: require("@/assets/SND01_sine/toggle_on.wav"),       volume: 0.40, },
      { key: "toggle_off",                           source: require("@/assets/SND01_sine/toggle_off.wav"),       volume: 0.40, },
      { key: "notification",                         source: require("@/assets/SND01_sine/notification.wav"),       volume: 0.40, },

      // { key: "click2",                               source: require("@/assets/UniversalSoundFX/IMPACTS/Wood/IMPACT_Wood_Plank_On_Wood_Pile_06_Short_mono.wav"),      volume: 0.40, },
      // { key: "click3",                               source: require("@/assets/UniversalSoundFX/USER_INTERFACES/Beeps/UI_Beep_Single_Saw_stereo.wav"),                volume: 0.40, },
      // { key: "click4",                               source: require("@/assets/UniversalSoundFX/USER_INTERFACES/Sci-Fi/UI_SCI-FI_Compute_02_Wet_stereo.wav"),         volume: 0.40, },
      { key: "patxu",                                source: require("@/static/sound_effect/soundeffect_lab/patxu.mp3"),                                              volume: 0.50, },
      { key: "poon",                                 source: require("@/assets/UniversalSoundFX/PUZZLES/PUZZLE_Success_Bright_Voice_Two_Note_Fast_Delay_stereo.wav"), volume: 0.10, },
      { key: "bird",                                 source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Bird_Crow_01_mono.wav"),                               volume: 0.50, },
      { key: "rooster",                              source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Rooster_Crow_01_mono.wav"),                            volume: 0.30, },
      // { key: "dog1",                                 source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Dog_Bark_01_Mono.wav"),                                volume: 0.50, },
      // { key: "dog2",                                 source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Dog_Bark_02_Mono.wav"),                                volume: 0.50, },
      // { key: "dog3",                                 source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Dog_Yelp_01_Mono.wav"),                                volume: 0.50, },
      { key: "room_entry",                           source: require("@/assets/UniversalSoundFX/PUZZLES/PUZZLE_Success_Guitar_2_Slow_Three_Note_Dry_stereo.wav"),              volume: 0.50, },
      { key: "room_leave",                           source: require("@/assets/UniversalSoundFX/DOORS_GATES_DRAWERS/DOOR_Indoor_Wood_Close_stereo.wav"),              volume: 0.50, },
      { key: "deden",                                source: require("@/static/sound_effect/soundeffect_lab/deden.mp3"),                                              volume: 0.20, },
      { key: "pipopipo",                             source: require("@/static/sound_effect/soundeffect_lab/pipopipo.mp3"),                                           volume: 0.20, },
      { key: "correct",                              source: require("@/static/sound_effect/oto_logic/Quiz-Correct_Answer02-1.mp3"),                                  volume: 0.20, },
      { key: "mistake",                              source: require("@/static/sound_effect/oto_logic/Quiz-Wrong_Buzzer02-1.mp3"),                                    volume: 0.20, },
      { key: "timeout",                              source: require("@/static/sound_effect/soundeffect_lab/bubuu.mp3"),                                              volume: 0.20, },
      { key: "draw",                                 source: require("@/static/sound_effect/soundeffect_lab/stupid5.mp3"),                                            volume: 0.20, },
      { key: "new_challenge",                        source: require("@/static/sound_effect/soundeffect_lab/decision5.mp3"),                                          volume: 0.30, },
      { key: "notify",                               source: require("@/static/sound_effect/soundeffect_lab/decision29.mp3"),                                         volume: 0.30, },
      { key: "spon",                                 source: require("@/static/sound_effect/oto_logic/Onmtp-Pop01-4.mp3"),                                            volume: 0.50, },
      { key: "pon",                                  source: require("@/assets/UniversalSoundFX/CARTOON/POP_Mouth_mono.wav"),                                         volume: 0.40, },
      { key: "piece_put",                            source: require("@/assets/UniversalSoundFX/SPORTS/Table_Tennis/TABLE_TENNIS_Racket_Ball_Hit_07_Hard_mono.wav"),         volume: 0.20, },
    ]
  }
}
