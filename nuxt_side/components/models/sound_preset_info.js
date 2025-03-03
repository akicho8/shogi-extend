// 音量確認: http://localhost:4000/sound-test

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SoundPresetInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      // BGM系
      { key: "bgm_start1",    name: "開始BGM1", source: require("@/assets/bgm/bgm_start1.mp3"),  volume: 0.30, },
      { key: "bgm_ending1",   name: "終局BGM1", source: require("@/assets/bgm/bgm_ending1.mp3"), volume: 0.30, },
      { key: "bgm_ending2",   name: "終局BGM2", source: require("@/assets/bgm/bgm_ending2.mp3"), volume: 0.60, },
      { key: "bgm_ending3",   name: "終局BGM3", source: require("@/assets/bgm/bgm_ending3.mp3"), volume: 0.40, },
      { key: "bgm_ending4",   name: "終局BGM4", source: require("@/assets/bgm/bgm_ending4.mp3"), volume: 0.30, },
      { key: "bgm_ending5",   name: "終局BGM5", source: require("@/assets/bgm/bgm_ending5.mp3"), volume: 0.40, },
      { key: "bgm_ending6",   name: "終局BGM6", source: require("@/assets/bgm/bgm_ending6.mp3"), volume: 0.30, },

      // 基本UI
      { key: "se_click",                      name: "クリック",                 source: require("@/assets/SND01_sine/tap_03.wav"),          volume: 0.3, },
      { key: "se_toggle_on",                  name: "トグルON",                 source: require("@/assets/SND01_sine/toggle_on.wav"),       volume: 0.2, },
      { key: "se_toggle_off",                 name: "トグルOFF",                source: require("@/assets/SND01_sine/toggle_off.wav"),      volume: 0.2, },
      { key: "se_select",                     name: "ラジオボタン選択",         source: require("@/assets/SND01_sine/select.wav"),          volume: 0.3, },
      { key: "se_disabled",                   name: "禁止",                     source: require("@/assets/SND01_sine/disabled.wav"),        volume: 0.3, },
      { key: "se_notification",               name: "通知",                     source: require("@/assets/SND01_sine/notification.wav"),    volume: 0.3, },
      { key: "se_caution",                    name: "危険",                     source: require("@/assets/SND01_sine/caution.wav"),         volume: 0.3, },
      { key: "se_transition_up",              name: "遷移(進む)",               source: require("@/assets/SND01_sine/transition_up.wav"),   volume: 0.2, },
      { key: "se_transition_down",            name: "遷移(戻る)",               source: require("@/assets/SND01_sine/transition_down.wav"), volume: 0.2, },
      { key: "se_celebration",                name: "完了祝福",                 source: require("@/assets/SND01_sine/celebration.wav"),     volume: 0.4, },
      { key: "se_progress",                   name: "処理中",                   source: require("@/assets/SND01_sine/progress_loop.wav"),   volume: 0.5, },

      // { key: "se_click",                                                     source: require("@/assets/USF/USER_INTERFACES/Beeps/UI_Beep_Double_Quick_Smooth_stereo.wav"),  volume: 0.40, },
      // { key: "se_click",                                                     source: require("@/assets/USF/BUTTONS/BUTTON_Very_Bright_Click_mono.wav"),                     volume: 0.2, },
      // { key: "se_toggle_on",                                                 source: require("@/assets/USF/BUTTONS/BUTTON_Plastic_Light_Switch_On_mono.wav"),               volume: 0.3, },
      // { key: "se_toggle_off",                                                source: require("@/assets/USF/BUTTONS/BUTTON_Plastic_Light_Switch_Off_mono.wav"),              volume: 0.3, },
      // { key: "se_toggle_on",                                                 source: require("@/assets/USF/BUTTONS/BUTTON_Plastic_Light_Switch_On_mono.wav"),               volume: 0.3, },
      // { key: "se_toggle_off",                                                source: require("@/assets/USF/BUTTONS/BUTTON_Plastic_Light_Switch_Off_mono.wav"),              volume: 0.3, },
      // { key: "se_click2",                                                    source: require("@/assets/USF/IMPACTS/Wood/IMPACT_Wood_Plank_On_Wood_Pile_06_Short_mono.wav"), volume: 0.40, },
      // { key: "se_click3",                                                    source: require("@/assets/USF/USER_INTERFACES/Beeps/UI_Beep_Single_Saw_stereo.wav"),           volume: 0.40, },
      // { key: "se_click4",                                                    source: require("@/assets/USF/USER_INTERFACES/Sci-Fi/UI_SCI-FI_Compute_02_Wet_stereo.wav"),    volume: 0.40, },
      // { key: "se_click4",                                                    source: require("@/assets/USF/USER_INTERFACES/Sci-Fi/UI_SCI-FI_Compute_02_Wet_stereo.wav"),    volume: 0.40, },

      ////////////////////////////////////////////////////////////////////////////////

      { key: "o",             name: "正解",                                     source: require("@/static/sound_effect/oto_logic/Quiz-Correct_Answer02-1.mp3"),                                  volume: 0.20, },
      { key: "x",             name: "不正解",                                   source: require("@/static/sound_effect/oto_logic/Quiz-Wrong_Buzzer02-1.mp3"),                                    volume: 0.20, },
      { key: "start",         name: "開始",                                     source: require("@/static/sound_effect/oto_logic/Quiz-Question03-1.mp3"),                                        volume: 0.15, },
      { key: "lose",          name: "負け",                                     source: require("@/static/sound_effect/oto_logic/Onmtp-Ding05-1.mp3"),                                           volume: 0.40, },
      { key: "win",           name: "勝ち",                                     source: require("@/static/sound_effect/soundeffect_lab/kansei.mp3"),                                             volume: 0.20, },

      { key: "se_pon",  name: "ポン",                                           source: require("@/assets/USF/CARTOON/POP_Mouth_mono.wav"),                                         volume: 0.40, },
      { key: "se_poon", name: "綺麗なポォーン",                                 source: require("@/assets/USF/PUZZLES/PUZZLE_Success_Bright_Voice_Two_Note_Fast_Delay_stereo.wav"), volume: 0.10, },

      { key: "deden",                                                           source: require("@/static/sound_effect/soundeffect_lab/deden.mp3"),                    volume: 0.20, },
      { key: "pipopipo",                                                        source: require("@/static/sound_effect/soundeffect_lab/pipopipo.mp3"),                 volume: 0.20, },
      { key: "correct",                                                         source: require("@/static/sound_effect/oto_logic/Quiz-Correct_Answer02-1.mp3"),        volume: 0.20, },
      { key: "mistake",                                                         source: require("@/static/sound_effect/oto_logic/Quiz-Wrong_Buzzer02-1.mp3"),          volume: 0.20, },
      { key: "timeout",                                                         source: require("@/static/sound_effect/soundeffect_lab/bubuu.mp3"),                    volume: 0.20, },
      { key: "draw",                                                            source: require("@/static/sound_effect/soundeffect_lab/stupid5.mp3"),                  volume: 0.20, },
      { key: "new_challenge",                                                   source: require("@/static/sound_effect/soundeffect_lab/decision5.mp3"),                volume: 0.30, },
      { key: "notify",                                                          source: require("@/static/sound_effect/soundeffect_lab/decision29.mp3"),               volume: 0.30, },
      { key: "spon",                                                            source: require("@/static/sound_effect/oto_logic/Onmtp-Pop01-4.mp3"),                  volume: 0.50, },

      // ▼駒音
      // { key: "se_piece_put",                                                 source: require("@/static/sound_effect/soundeffect_lab/shogi_piece_puton.mp3"),               volume: 0.8, },
      // { key: "se_piece_put",                                                 source: require("@/assets/USF/IMPACTS/Stone/IMPACT_Stone_On_Stone_05_mono.wav"), volume: 0.4, },
      // { key: "se_piece_put",                                                 source: require("@/assets/USF/THUDS_THUMPS/THUD_Subtle_Tap_mono.wav"),           volume: 0.8, },
      { key: "se_piece_lift",                 name: "持ち上げる",               source: require("@/assets/SND01_sine/tap_03.wav"), volume: 0.3, },
      { key: "se_piece_lift_cancel",          name: "持ち上げキャンセル",       source: require("@/assets/USF/USER_INTERFACES/Appear_Disappear/UI_Animate_Noise_Glide_Disappear_stereo.wav"), volume: 0.4, },
      { key: "se_piece_put",                  name: "置く",                     source: require("@/assets/USF/BUTTONS/BUTTON_Light_Switch_03_stereo.wav"), volume: 0.3, },
      // { key: "se_piece_select",                                              source: require("@/assets/USF/BUTTONS/BUTTON_Light_Switch_03_stereo.wav"), volume: 0.2, },

      // ▼思考印をセルに付ける / 外す

      // 8BIT
      { key: "se_think_mark_at_cell_on",      name: "思考印描画",               source: require("@/assets/USF/8BIT/Beeps/8BIT_RETRO_Beep_Smooth_Sine_mono.wav"),      volume: 0.15, },
      { key: "se_think_mark_at_cell_off",     name: "思考印消去",               source: require("@/assets/USF/8BIT/Beeps/8BIT_RETRO_Beep_Smooth_Sine_Deep_mono.wav"), volume: 0.15, },
      // { key: "se_think_mark_at_cell_on",                                     source: require("@/assets/USF/8BIT/Coin_Collect/8BIT_RETRO_Coin_Collect_Two_Note_Bright_Fast_mono.wav"),               volume: 0.30, },

      // Factoio 搬送ベルト風
      // { key: "se_think_mark_at_cell_on",                                     source: require("@/assets/USF/IMPACTS/Snappy/IMPACT_Snappy_01_mono.wav"),               volume: 0.30, },
      // { key: "se_think_mark_at_cell_off",                                    source: require("@/assets/USF/IMPACTS/Snappy/IMPACT_Snappy_02_mono.wav"),                    volume: 0.30, },

      // バリエーション
      // { key: "se_think_mark_at_cell_off",                                    source: require("@/assets/USF/8BIT/Hits_Bumps/8BIT_RETRO_Hit_Bump_Distorted_Tap_mono.wav"),                    volume: 0.10, },
      // { key: "se_think_mark_at_cell_off",                                    source: require("@/assets/USF/8BIT/Beeps/8BIT_RETRO_Beep_Zap_Fast_mono.wav"),                    volume: 0.30, },

      // { key: "se_tebanjanainoni_sawaruna", name: "手番違い",                 source: require("@/assets/USF/ALARMS/Digital/ALARM_Short_Distorted_loop_stereo.wav"),                    volume: 0.30, },

      { key: "se_aitenokoma_ugokasouto_suna", name: "相手の駒を動かそうとした", source: require("@/assets/SND01_sine/disabled.wav"), volume: 0.3, },
      { key: "se_tebanjanainoni_sawaruna",    name: "手番違い",                 source: require("@/assets/SND01_sine/disabled.wav"), volume: 0.3, },

      { key: "se_room_entry",                 name: "入室",                     source: require("@/assets/USF/DOORS_GATES_DRAWERS/DOOR_Metal_Open_Creak_stereo.wav"), volume: 0.50, },
      { key: "se_room_leave",                 name: "退室",                     source: require("@/assets/USF/DOORS_GATES_DRAWERS/DOOR_Owen_Close_stereo.wav"),       volume: 0.50, },

      { key: "se_moo1",                       name: "牛1",                      source: require("@/assets/USF/ANIMALS/ANIMAL_Cow_Moo_01_mono.wav"), volume: 0.5, },
      { key: "se_moo2",                       name: "牛2",                      source: require("@/assets/USF/ANIMALS/ANIMAL_Cow_Moo_02_mono.wav"), volume: 0.5, },
      { key: "se_moo3",                       name: "牛3",                      source: require("@/assets/USF/ANIMALS/ANIMAL_Cow_Moo_03_mono.wav"), volume: 0.5, },

      { key: "se_niwatori",                   name: "にわとり (対局開始)",      source: require("@/assets/USF/ANIMALS/ANIMAL_Rooster_Crow_01_mono.wav"), volume: 0.5, },

      { key: "se_chat_message_receive",       name: "チャットの発言受信",       source: require("@/assets/USF/CARTOON/POP_Mouth_Darker_mono.wav"), volume: 0.50, },

      // { key: "se_ping",                    name: "PING",                     source: require("@/assets/USF/SPORTS/Table_Tennis/TABLE_TENNIS_Racket_Ball_Hit_01_mono.wav"), volume: 0.50, },
      // { key: "se_pong",                    name: "PONG",                     source: require("@/assets/USF/SPORTS/Table_Tennis/TABLE_TENNIS_Racket_Ball_Hit_02_mono.wav"), volume: 0.50, },

    ]
  }
}
