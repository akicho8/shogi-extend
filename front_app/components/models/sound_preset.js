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
      { key: "dog1",           source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Dog_Bark_01_Mono.wav"),                                volume: 0.50, },
      { key: "dog2",           source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Dog_Bark_02_Mono.wav"),                                volume: 0.50, },
      { key: "dog3",           source: require("@/assets/UniversalSoundFX/ANIMALS/ANIMAL_Dog_Yelp_01_Mono.wav"),                                volume: 0.50, },
      // { key: "door_open",      source: require("@/assets/UniversalSoundFX/DOORS_GATES_DRAWERS/DOOR_Indoor_Wood_Open_stereo.wav"),               volume: 0.50, },
      { key: "door_close",     source: require("@/assets/UniversalSoundFX/DOORS_GATES_DRAWERS/DOOR_Indoor_Wood_Close_stereo.wav"),              volume: 0.50, },
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

      // for kill_attack
      // { key: "HAMMER_Hit_Body_Break_stereo",                    source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Hammer/HAMMER_Hit_Body_Break_stereo.wav"),                    volume: 0.20, },
      // { key: "HAMMER_Hit_Body_Gore_stereo",                     source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Hammer/HAMMER_Hit_Body_Gore_stereo.wav"),                     volume: 0.20, },
      // { key: "HAMMER_Hit_Body_stereo",                          source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Hammer/HAMMER_Hit_Body_stereo.wav"),                          volume: 0.20, },
      // { key: "HAMMER_Hit_Metal_Armor_stereo",                   source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Hammer/HAMMER_Hit_Metal_Armor_stereo.wav"),                   volume: 0.20, },
      // { key: "HAMMER_Hit_Wood_Shield_Break_Much_Debris_stereo", source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Hammer/HAMMER_Hit_Wood_Shield_Break_Much_Debris_stereo.wav"), volume: 0.20, },
      // { key: "HAMMER_Hit_Wood_Shield_Break_stereo",             source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Hammer/HAMMER_Hit_Wood_Shield_Break_stereo.wav"),             volume: 0.20, },
      // { key: "HAMMER_Hit_Wood_Shield_stereo",                   source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Hammer/HAMMER_Hit_Wood_Shield_stereo.wav"),                   volume: 0.20, },
      { key: "SWORD_Hit_Armor_Hard_RR1_mono",                        source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Swords/SWORD_Hit_Armor_Hard_RR1_mono.wav"),            volume: 0.20, },
      { key: "SWORD_Hit_Armor_Hard_RR3_mono",                        source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Swords/SWORD_Hit_Armor_Hard_RR3_mono.wav"),            volume: 0.20, },
      { key: "SWORD_Whoosh_Hit_Armor_Hard_RR1_mono",                 source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Swords/SWORD_Whoosh_Hit_Armor_Hard_RR1_mono.wav"),     volume: 0.20, },
      { key: "SWORD_Whoosh_Hit_Armor_Hard_RR2_mono",                 source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Swords/SWORD_Whoosh_Hit_Armor_Hard_RR2_mono.wav"),     volume: 0.20, },
      // { key: "VOICE_MALE_Enemy_Down_1_Aggressive_mono", source: require("@/assets/UniversalSoundFX/VOICES/Words_Phrases/Male_A/VOICE_MALE_Enemy_Down_1_Aggressive_mono.wav"),     volume: 0.20, },
      // { key: "SWORD_Swing_Hit_Wood_Shield_Break_Much_Debris_stereo", source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Swords/SWORD_Swing_Hit_Wood_Shield_Break_Much_Debris_stereo.wav"),     volume: 0.20, },
      // { key: "SWORD_Swing_Hit_Solid_Metal_Deep_mono",                source: require("@/assets/UniversalSoundFX/WEAPONS/Melee/Swords/SWORD_Swing_Hit_Solid_Metal_Deep_mono.wav"),     volume: 0.20, },

      // for move
      // { key: "VOICE_Martial_Art_Shout_05_mono",         source: require("@/assets/UniversalSoundFX/VOICES/Martial_Arts_Male/VOICE_Martial_Art_Shout_05_mono.wav"),       volume: 0.50, },
      // { key: "VOICE_Martial_Art_Shout_01_mono",         source: require("@/assets/UniversalSoundFX/VOICES/Martial_Arts_Male/VOICE_Martial_Art_Shout_01_mono.wav"),       volume: 0.50, },
      { key: "VOICE_Martial_Art_Shout_06_mono",         source: require("@/assets/UniversalSoundFX/VOICES/Martial_Arts_Male/VOICE_Martial_Art_Shout_06_mono.wav"),       volume: 0.50, },
      { key: "VOICE_Martial_Art_Shout_07_mono",         source: require("@/assets/UniversalSoundFX/VOICES/Martial_Arts_Male/VOICE_Martial_Art_Shout_07_mono.wav"),       volume: 0.50, },
      { key: "VOICE_Martial_Art_Shout_08_mono",         source: require("@/assets/UniversalSoundFX/VOICES/Martial_Arts_Male/VOICE_Martial_Art_Shout_08_mono.wav"),       volume: 0.50, },
      { key: "VOICE_Martial_Art_Shout_12_mono",         source: require("@/assets/UniversalSoundFX/VOICES/Martial_Arts_Male/VOICE_Martial_Art_Shout_12_mono.wav"),       volume: 0.50, },
      // { key: "VOICE_Martial_Art_Shout_20_mono",         source: require("@/assets/UniversalSoundFX/VOICES/Martial_Arts_Male/VOICE_Martial_Art_Shout_20_mono.wav"),       volume: 0.50, },
      // { key: "VOICE_Martial_Art_Shout_21_mono",         source: require("@/assets/UniversalSoundFX/VOICES/Martial_Arts_Male/VOICE_Martial_Art_Shout_21_mono.wav"),       volume: 0.50, },

      // for powerup
      // { key: "EXCLAMATION_Male_B_Horray_01_mono",       source: require("@/assets/UniversalSoundFX/VOICES/Exclamations/EXCLAMATION_Male_B_Horray_01_mono.wav"),       volume: 0.50, },
      // { key: "EXCLAMATION_Male_B_Whoo_01_mono",         source: require("@/assets/UniversalSoundFX/VOICES/Exclamations/EXCLAMATION_Male_B_Whoo_01_mono.wav"),       volume: 0.50, },
      // { key: "EXCLAMATION_Male_B_WoahahahaYes_01_mono", source: require("@/assets/UniversalSoundFX/VOICES/Exclamations/EXCLAMATION_Male_B_WoahahahaYes_01_mono.wav"),       volume: 0.50, },

      // for appear

      // for killed_and_death
      { key: "SCREAM_Male_B_06_mono",            source: require("@/assets/UniversalSoundFX/VOICES/Screams/SCREAM_Male_B_06_mono.wav"),                volume: 0.60, },
      { key: "SCREAM_Male_B_07_mono",            source: require("@/assets/UniversalSoundFX/VOICES/Screams/SCREAM_Male_B_07_mono.wav"),                volume: 0.60, },
      { key: "SCREAM_Male_B_08_mono",            source: require("@/assets/UniversalSoundFX/VOICES/Screams/SCREAM_Male_B_08_mono.wav"),                volume: 0.60, },
      { key: "GROAN_Male_Hurt_Long_mono",        source: require("@/assets/UniversalSoundFX/VOICES/Grunts_Groans_Hurt/GROAN_Male_Hurt_Long_mono.wav"), volume: 0.60, },
      { key: "GROAN_Male_Hurt_Long_Pain_mono",   source: require("@/assets/UniversalSoundFX/VOICES/Grunts_Groans_Hurt/GROAN_Male_Hurt_Long_Pain_mono.wav"),       volume: 0.60, },
      { key: "GRUNT_Male_B_Hurt_Medium_01_mono", source: require("@/assets/UniversalSoundFX/VOICES/Grunts_Groans_Hurt/GRUNT_Male_B_Hurt_Medium_01_mono.wav"),     volume: 0.60, },
    ]
  }
}
