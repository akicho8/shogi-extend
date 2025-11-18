// 音量確認: http://localhost:4000/sound-test

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SoundPresetInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      ////////////////////////////////////////////////////////////////////////////////

      // 基本UI
      { key: "se_click",           name: "クリック",         volume: 0.3, source: require("@/assets/SND01_sine/tap_03.wav"),          },
      { key: "se_toggle_on",       name: "トグルON",         volume: 0.2, source: require("@/assets/SND01_sine/toggle_on.wav"),       },
      { key: "se_toggle_off",      name: "トグルOFF",        volume: 0.2, source: require("@/assets/SND01_sine/toggle_off.wav"),      },
      { key: "se_select",          name: "ラジオボタン選択", volume: 0.3, source: require("@/assets/SND01_sine/select.wav"),          }, // いまいちなので使うな
      { key: "se_disabled",        name: "禁止",             volume: 0.3, source: require("@/assets/SND01_sine/disabled.wav"),        },
      { key: "se_notification",    name: "通知",             volume: 0.4, source: require("@/assets/SND01_sine/notification.wav"),    },
      { key: "se_caution",         name: "危険",             volume: 0.3, source: require("@/assets/SND01_sine/caution.wav"),         },
      { key: "se_transition_up",   name: "遷移(進む)",       volume: 0.2, source: require("@/assets/SND01_sine/transition_up.wav"),   },
      { key: "se_transition_down", name: "遷移(戻る)",       volume: 0.2, source: require("@/assets/SND01_sine/transition_down.wav"), },
      { key: "se_celebration",     name: "完了祝福",         volume: 0.4, source: require("@/assets/SND01_sine/celebration.wav"),     },
      { key: "se_progress",        name: "処理中",           volume: 0.5, source: require("@/assets/SND01_sine/progress_loop.wav"),   },

      // { key: "se_click",      volume: 0.40, source: require("@/assets/USF/USER_INTERFACES/Beeps/UI_Beep_Double_Quick_Smooth_stereo.wav"),  },
      // { key: "se_click",      volume: 0.2,  source: require("@/assets/USF/BUTTONS/BUTTON_Very_Bright_Click_mono.wav"),                     },
      // { key: "se_toggle_on",  volume: 0.3,  source: require("@/assets/USF/BUTTONS/BUTTON_Plastic_Light_Switch_On_mono.wav"),               },
      // { key: "se_toggle_off", volume: 0.3,  source: require("@/assets/USF/BUTTONS/BUTTON_Plastic_Light_Switch_Off_mono.wav"),              },
      // { key: "se_toggle_on",  volume: 0.3,  source: require("@/assets/USF/BUTTONS/BUTTON_Plastic_Light_Switch_On_mono.wav"),               },
      // { key: "se_toggle_off", volume: 0.3,  source: require("@/assets/USF/BUTTONS/BUTTON_Plastic_Light_Switch_Off_mono.wav"),              },
      // { key: "se_click2",     volume: 0.40, source: require("@/assets/USF/IMPACTS/Wood/IMPACT_Wood_Plank_On_Wood_Pile_06_Short_mono.wav"), },
      // { key: "se_click3",     volume: 0.40, source: require("@/assets/USF/USER_INTERFACES/Beeps/UI_Beep_Single_Saw_stereo.wav"),           },
      // { key: "se_click4",     volume: 0.40, source: require("@/assets/USF/USER_INTERFACES/Sci-Fi/UI_SCI-FI_Compute_02_Wet_stereo.wav"),    },
      // { key: "se_click4",     volume: 0.40, source: require("@/assets/USF/USER_INTERFACES/Sci-Fi/UI_SCI-FI_Compute_02_Wet_stereo.wav"),    },

      ////////////////////////////////////////////////////////////////////////////////

      { key: "o",           name: "正解",           volume: 0.20, source: require("@/static/sound_effect/oto_logic/Quiz-Correct_Answer02-1.mp3"),                     },
      { key: "x",           name: "不正解",         volume: 0.20, source: require("@/static/sound_effect/oto_logic/Quiz-Wrong_Buzzer02-1.mp3"),                       },
      { key: "start",       name: "開始",           volume: 0.15, source: require("@/static/sound_effect/oto_logic/Quiz-Question03-1.mp3"),                           },
      { key: "lose",        name: "負け",           volume: 0.40, source: require("@/static/sound_effect/oto_logic/Onmtp-Ding05-1.mp3"),                              },
      { key: "win",         name: "勝ち",           volume: 0.20, source: require("@/static/sound_effect/soundeffect_lab/kansei.mp3"),                                },

      { key: "se_pon",      name: "ポン(高)",       volume: 0.10, source: require("@/static/sound_effect/oto_logic/Onmtp-Pop01-4.mp3"),                               },
      { key: "se_po",       name: "ポ(低)",         volume: 0.20, source: require("@/assets/USF/CARTOON/POP_Mouth_mono.wav"),                                         },
      { key: "se_poon",     name: "綺麗なポォーン", volume: 0.10, source: require("@/assets/USF/PUZZLES/PUZZLE_Success_Bright_Voice_Two_Note_Fast_Delay_stereo.wav"), },

      { key: "se_deden",    name: "デデン",         volume: 0.30, source: require("@/static/sound_effect/soundeffect_lab/deden.mp3"),                                 },
      { key: "se_pipopipo", name: "ピポピポピポン", volume: 0.20, source: require("@/static/sound_effect/soundeffect_lab/pipopipo.mp3"),                              },
      { key: "correct",                             volume: 0.20, source: require("@/static/sound_effect/oto_logic/Quiz-Correct_Answer02-1.mp3"),                     },
      { key: "mistake",                             volume: 0.20, source: require("@/static/sound_effect/oto_logic/Quiz-Wrong_Buzzer02-1.mp3"),                       },
      { key: "se_bubuu",    name: "ブブー",         volume: 0.20, source: require("@/static/sound_effect/soundeffect_lab/bubuu.mp3"),                                 },
      { key: "draw",                                volume: 0.20, source: require("@/static/sound_effect/soundeffect_lab/stupid5.mp3"),                               },
      { key: "new_challenge",                       volume: 0.30, source: require("@/static/sound_effect/soundeffect_lab/decision5.mp3"),                             },
      { key: "notify",                              volume: 0.30, source: require("@/static/sound_effect/soundeffect_lab/decision29.mp3"),                            },

      // ▼駒音
      // { key: "se_piece_put",                                                volume: 0.8,  source: require("@/static/sound_effect/soundeffect_lab/shogi_piece_puton.mp3"),                               },
      // { key: "se_piece_put",                                                volume: 0.4,  source: require("@/assets/USF/IMPACTS/Stone/IMPACT_Stone_On_Stone_05_mono.wav"),                              },
      // { key: "se_piece_put",                                                volume: 0.8,  source: require("@/assets/USF/THUDS_THUMPS/THUD_Subtle_Tap_mono.wav"),                                        },
      { key: "se_piece_lift",                name: "持ち上げる",               volume: 0.3,  source: require("@/assets/SND01_sine/tap_03.wav"),                                                            },
      { key: "se_piece_lift_cancel",         name: "持ち上げキャンセル",       volume: 0.3,  source: require("@/assets/USF/USER_INTERFACES/Appear_Disappear/UI_Animate_Noise_Glide_Disappear_stereo.wav"), },
      { key: "se_piece_put",                 name: "置く",                     volume: 0.3,  source: require("@/assets/USF/BUTTONS/BUTTON_Light_Switch_03_stereo.wav"),                                    }, // ::SE_PIECE_PUT_VOLUME:: nuxt_side/components/ShareBoard/models/param_info.js と合わせる
      // { key: "se_piece_put",                 name: "置く",                     volume: 0.3,  source: require("@/assets/USF/WEAPONS/Firearms/Fire_First_Person_Shooter_FPS/FIREARM_Shotgun_Model_02_Fire_Single_RR1_stereo.wav"),                                    }, // ::SE_PIECE_PUT_VOLUME:: nuxt_side/components/models/sound_preset_info.js と合わせる
      // { key: "se_piece_put",                 name: "置く",                     volume: 0.3,  source: require("@/assets/USF/IMPACTS/Bricks/IMPACT_Brick_vs_Brick_RR1_mono.wav"),                                    }, // ::SE_PIECE_PUT_VOLUME:: nuxt_side/components/models/sound_preset_info.js と合わせる
      // { key: "se_piece_select",                                             volume: 0.2,  source: require("@/assets/USF/BUTTONS/BUTTON_Light_Switch_03_stereo.wav"),                                    },

      // ▼思考印をセルに付ける / 外す

      // 8BIT
      { key: "se_think_mark_at_cell_on",     name: "思考印描画",               volume: 0.1, source: require("@/assets/USF/8BIT/Beeps/8BIT_RETRO_Beep_Smooth_Sine_mono.wav"),                              },
      { key: "se_think_mark_at_cell_off",    name: "思考印消去",               volume: 0.1, source: require("@/assets/USF/8BIT/Beeps/8BIT_RETRO_Beep_Smooth_Sine_Deep_mono.wav"),                         },
      // { key: "se_think_mark_at_cell_on",                                    volume: 0.30, source: require("@/assets/USF/8BIT/Coin_Collect/8BIT_RETRO_Coin_Collect_Two_Note_Bright_Fast_mono.wav"),      },

      // Factoio 搬送ベルト風
      // { key: "se_think_mark_at_cell_on",                                    volume: 0.30, source: require("@/assets/USF/IMPACTS/Snappy/IMPACT_Snappy_01_mono.wav"),                                     },
      // { key: "se_think_mark_at_cell_off",                                   volume: 0.30, source: require("@/assets/USF/IMPACTS/Snappy/IMPACT_Snappy_02_mono.wav"),                                     },

      // バリエーション
      // { key: "se_think_mark_at_cell_off",                                   volume: 0.10, source: require("@/assets/USF/8BIT/Hits_Bumps/8BIT_RETRO_Hit_Bump_Distorted_Tap_mono.wav"),                   },
      // { key: "se_think_mark_at_cell_off",                                   volume: 0.30, source: require("@/assets/USF/8BIT/Beeps/8BIT_RETRO_Beep_Zap_Fast_mono.wav"),                                 },

      // { key: "se_tebanjanainoni_sawanna", name: "手番違い",                 volume: 0.30, source: require("@/assets/USF/ALARMS/Digital/ALARM_Short_Distorted_loop_stereo.wav"),                         },

      { key: "se_aitenokoma_sawannna",       name: "相手の駒を動かそうとした", volume: 0.3,  source: require("@/assets/SND01_sine/disabled.wav"),                                                          },
      { key: "se_tebanjanainoni_sawanna",    name: "手番違い",                 volume: 0.3,  source: require("@/assets/SND01_sine/disabled.wav"),                                                          },

      { key: "se_room_entry",                name: "入室",                     volume: 0.50, source: require("@/assets/USF/DOORS_GATES_DRAWERS/DOOR_Metal_Open_Creak_stereo.wav"),                         },
      { key: "se_room_leave",                name: "退室",                     volume: 0.50, source: require("@/assets/USF/DOORS_GATES_DRAWERS/DOOR_Owen_Close_stereo.wav"),                               },

      { key: "se_moo1",                      name: "牛1",                      volume: 0.5,  source: require("@/assets/USF/ANIMALS/ANIMAL_Cow_Moo_01_mono.wav"),                                           },
      { key: "se_moo2",                      name: "牛2",                      volume: 0.5,  source: require("@/assets/USF/ANIMALS/ANIMAL_Cow_Moo_02_mono.wav"),                                           },
      { key: "se_moo3",                      name: "牛3",                      volume: 0.5,  source: require("@/assets/USF/ANIMALS/ANIMAL_Cow_Moo_03_mono.wav"),                                           },

      { key: "se_niwatori",                  name: "コケコッコー",             volume: 0.5,  source: require("@/assets/USF/ANIMALS/ANIMAL_Rooster_Crow_01_mono.wav"),                                      },

      { key: "se_chat_message_receive",      name: "チャットの発言受信",       volume: 0.1, source: require("@/static/sound_effect/oto_logic/Onmtp-Pop01-4.mp3"),                                         },
      // { key: "se_chat_message_receive",      name: "チャットの発言受信",       volume: 0.50, source: require("@/assets/USF/CARTOON/POP_Mouth_Darker_mono.wav"),                                            },
      // { key: "se_pon",                       name: "ポン(高)",                 volume: 0.10, source: require("@/static/sound_effect/oto_logic/Onmtp-Pop01-4.mp3"),                               },

      // { key: "se_ping",                   name: "PING",                     volume: 0.50, source: require("@/assets/USF/SPORTS/Table_Tennis/TABLE_TENNIS_Racket_Ball_Hit_01_mono.wav"),                 },
      // { key: "se_pong",                   name: "PONG",                     volume: 0.50, source: require("@/assets/USF/SPORTS/Table_Tennis/TABLE_TENNIS_Racket_Ball_Hit_02_mono.wav"),                 },
    ]
  }

  // // マスターボリュームの初期値を 0.5 にしている影響でもともと 1.0 を想定で設定していた効果音ボリュームを2倍しておく
  // get volume_x2() {
  //   return this.volume * 2.0
  // }
}
