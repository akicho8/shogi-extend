<template lang="pug">
client-only
  .SbApp(:style="component_style" :class="component_class")
    | {{$debug.trace('SbApp', 'render')}}
    DebugBox.is-hidden-mobile(v-if="development_p && false")
      p new_v.os_dnd_count: {{new_v.os_dnd_count}}
      p appearance_theme_key: {{appearance_theme_key}}
      p mobile_vertical_key: {{mobile_vertical_key}}
      p watching_member_count: {{watching_member_count}}
      p order_enable_p: {{order_enable_p}}

      p cc_timeout_modal_instance: {{!!cc_timeout_modal_instance}}
      p cc_timeout_judge_delay_id: {{cc_timeout_judge_delay_id}}

      p current_xmatch_rule_key: {{current_xmatch_rule_key}}
      p self_vs_self_p: {{self_vs_self_p}}

      template(v-if="clock_box")
        p rest: {{clock_box.current.rest}}
        p next_location: {{next_location.key}}
        p timer: {{clock_box.timer}}
        p pause_or_play_p: {{clock_box.pause_or_play_p}}
      p rs_send_success_p={{rs_send_success_p}}
      p rs_failed_count={{rs_failed_count}}
      p rs_seq_ids={{rs_seq_ids}}
      p $route.query: {{$route.query}}
      p sp_human_side: {{sp_human_side}}
      p current_turn_self_p: {{current_turn_self_p}}
      p current_turn_user_name: {{current_turn_user_name}}
      p current_turn: {{current_turn}}
      p viewpoint: {{viewpoint}}
      p sp_player_info: {{JSON.stringify(sp_player_info)}}
      //- p room_key: {{JSON.stringify(room_key)}}
      //- p user_name: {{JSON.stringify(user_name)}}
      //- p 人数: {{JSON.stringify(member_infos.length)}}
      //- p 手数: {{current_turn}} / {{turn_offset_max}}
      //- p SFEN: {{current_sfen}}
      //- p タイトル: {{current_title}}
      //- p 視点: {{viewpoint}}
      //- p モード: {{sp_mode}}
      //- p 視点: {{viewpoint}}
      //- p URL: {{current_url}}
      //- p サイドバー {{sidebar_p}}

    SbSidebar
    SbNavbar

    MainSection.is_mobile_padding_zero(v-if="room_creating_busy === 0")
      .container.is-fluid
        //- .is-desktop でデスクトップ以上のときだけ横並びになる
        .columns.is-centered.is-desktop.is-variable.is-0
          SbSp(ref="SbSp")
          SbMemberList
          SbActionLog(ref="SbActionLog")
        SbDebugPanels(v-if="debug_mode_p")
</template>

<script>
import _ from "lodash"

import { Location                          } from "shogi-player/components/models/location.js"

import { FormatTypeInfo                    } from "@/components/models/format_type_info.js"
import { autoexec_methods                  } from "@/components/models/autoexec_methods.js"

import { AppConfig                         } from "./models/mod_config.js"

import { support_parent                    } from "./support_parent.js"

import { mod_xtitle                        } from "./mod_xtitle.js"

import { mod_action_log                    } from "./action_log/mod_action_log.js"
import { mod_action_log_share              } from "./action_log/mod_action_log_share.js"

import { mod_turn_notify                   } from "./mod_turn_notify.js"
import { mod_otasuke                       } from "./mod_otasuke.js"
import { mod_order_main                    } from "./order_mod/mod_order_main.js"
import { mod_battle_session                } from "./mod_battle_session.js"
import { mod_chore                         } from "./mod_chore.js"
import { mod_guardian                      } from "./mod_guardian.js"
import { mod_handle_name                   } from "./mod_handle_name.js"
import { mod_urls                          } from "./mod_urls.js"
import { mod_share_data                    } from "./mod_share_data.js"
import { mod_edit_mode                     } from "./mod_edit_mode.js"
import { mod_yomikomi                      } from "./mod_yomikomi.js"
import { mod_sp                            } from "./mod_sp.js"
import { mod_perpetual                     } from "./perpetual/mod_perpetual.js"
import { mod_think_mark                } from "./think_mark/mod_think_mark.js"
import { mod_devise                        } from "./mod_devise.js"
import { mod_user_kick                     } from "./mod_user_kick.js"
import { mod_track_log                     } from "./track_log/mod_track_log.js"
import { mod_xmatch                        } from "./auto_matching/mod_xmatch.js"
import { mod_member_bc                     } from "./mod_member_bc.js"
import { mod_image_dl                      } from "./mod_image_dl.js"
import { mod_update                        } from "./mod_update.js"
import { mod_sound_bug                     } from "./sound/mod_sound_bug.js"
import { mod_sound_effect                  } from "./sound/mod_sound_effect.js"
import { mod_sound_resume                  } from "./sound/mod_sound_resume.js"
import { mod_general_setting               } from "./general_setting/mod_general_setting.js"
import { mod_debug                         } from "./mod_debug.js"
import { mod_help                          } from "./help_mod/mod_help.js"
import { mod_sidebar                       } from "./mod_sidebar.js"
import { mod_storage                       } from "./mod_storage.js"
import { mod_export                        } from "./mod_export.js"
import { mod_player_names                  } from "./mod_player_names.js"
import { mod_color_theme                   } from "./mod_color_theme.js"
import { mod_sfen_share                    } from "./mod_sfen_share.js"
import { mod_resend                        } from "./resend/mod_resend.js"
import { mod_force_sync                    } from "./mod_force_sync.js"
import { mod_illegal                       } from "./illegal/mod_illegal.js"
import { mod_board_preset_select           } from "./mod_board_preset_select.js"
import { mod_back_to                       } from "./mod_back_to.js"
import { mod_shortcut                      } from "./shortcut/mod_shortcut.js"
import { window_active_detector            } from "./window_active_detector.js"
import { browser_slide_lock                } from "./browser_slide_lock.js"

import { mod_room_cable                    } from "./room/mod_room_cable.js"
import { mod_room_setup_modal              } from "./room/mod_room_setup_modal.js"
import { mod_room_entry_leave              } from "./room/mod_room_entry_leave.js"
import { mod_room_board_setup              } from "./room/mod_room_board_setup.js"
import { mod_room_active_level             } from "./room/mod_room_active_level.js"
import { mod_room_members                  } from "./room/mod_room_members.js"
import { mod_room_recreate                 } from "./room/mod_room_recreate.js"
import { mod_room_url_copy                 } from "./room/mod_room_url_copy.js"
import { mod_room_setup_modal_autocomplete } from "./room/mod_room_setup_modal_autocomplete.js"

import { mod_member_list                   } from "./member_list_show/mod_member_list.js"
import { mod_member_info_modal             } from "./member_list_show/mod_member_info_modal.js"
import { mod_ping                          } from "./member_list_show/mod_ping.js"
import { mod_net_level                     } from "./member_list_show/mod_net_level.js"

import { mod_chat                          } from "./chat/mod_chat.js"
import { mod_chat_message_list             } from "./chat/mod_chat_message_list.js"
import { mod_chat_ai_trigger_rule          } from "./chat/mod_chat_ai_trigger_rule.js"
import { mod_chat_message_history          } from "./chat/mod_chat_message_history.js"

import { mod_console                       } from "./console/mod_console.js"

import { mod_clock_box                     } from "./clock/mod_clock_box.js"
import { mod_clock_box_timeout             } from "./clock/mod_clock_box_timeout.js"
import { mod_clock_decorator               } from "./clock/mod_clock_decorator.js"
import { mod_persistent_cc_params          } from "./clock/mod_persistent_cc_params.js"

import { mod_give_up                       } from "./give_up/mod_give_up.js"
import { mod_kifu_mail                     } from "./give_up/mod_kifu_mail.js"
import { mod_battle_save                   } from "./give_up/mod_battle_save.js"

import { mod_honpu_core                         } from "./honpu/mod_honpu_core.js"
import { mod_honpu_share                   } from "./honpu/mod_honpu_share.js"

import { mod_odai_maker                    } from "./fes/mod_odai_maker.js"
import { mod_client_vote                   } from "./fes/mod_client_vote.js"

import { mod_badge                         } from "./badge/mod_badge.js"
import { mod_badge_plus                    } from "./badge/mod_badge_plus.js"

import { mod_appearance_theme              } from "./appearance_theme/mod_appearance_theme.js"

import { mod_tweet                         } from "./tweet/mod_tweet.js"

import { mod_dashboard                     } from "./dashboard/mod_dashboard.js"

export default {
  name: "SbApp",
  mixins: [
    // どう見ても mixins の使い方を間違えている
    support_parent,
    autoexec_methods,
    mod_xtitle,

    mod_action_log,
    mod_action_log_share,

    mod_chat,
    mod_chat_message_list,
    mod_chat_ai_trigger_rule,
    mod_chat_message_history,

    mod_console,
    mod_persistent_cc_params,
    mod_turn_notify,
    mod_otasuke,
    mod_order_main,
    mod_member_list,
    mod_battle_session,
    mod_chore,
    mod_kifu_mail,
    mod_battle_save,
    mod_guardian,
    mod_handle_name,
    mod_member_info_modal,
    mod_urls,
    mod_share_data,
    mod_edit_mode,
    mod_yomikomi,
    mod_sp,
    mod_perpetual,
    mod_think_mark,
    mod_devise,
    mod_user_kick,
    mod_track_log,
    mod_xmatch,
    mod_member_bc,
    mod_net_level,
    mod_ping,
    mod_tweet,
    mod_dashboard,
    mod_image_dl,
    mod_update,
    mod_sound_bug,
    mod_sound_effect,
    mod_general_setting,
    mod_debug,
    mod_sound_resume,
    mod_help,
    mod_sidebar,
    mod_storage,
    mod_export,
    mod_player_names,
    mod_color_theme,
    mod_appearance_theme,
    mod_sfen_share,
    mod_resend,
    mod_force_sync,
    mod_illegal,
    mod_board_preset_select,
    mod_back_to,
    mod_shortcut,
    mod_give_up,
    mod_honpu_core,
    mod_honpu_share,
    mod_badge,
    mod_badge_plus,

    mod_room_recreate,
    mod_room_url_copy,
    mod_room_setup_modal_autocomplete,
    mod_room_cable,
    mod_room_setup_modal,
    mod_room_entry_leave,
    mod_room_board_setup,
    mod_room_active_level,
    mod_room_members,

    mod_odai_maker,
    mod_client_vote,

    window_active_detector,
    browser_slide_lock,

    // clock
    mod_clock_box,
    mod_clock_box_timeout,
    mod_clock_decorator,
  ],
  props: {
    config: { type: Object, required: true },
  },
  meta() {
    return {
      title: this.page_title,
    }
  },
  data() {
    return {
      // watch して url に反映するもの
      current_sfen: this.config.record.sfen_body,    // 渡している棋譜
      current_turn: this.config.record.initial_turn, // 現在の手数
      viewpoint:    this.config.record.viewpoint,    // Twitter画像の向き

      // urlには反映しない
      turn_offset_max: null,                            // 最後の手数

      record:          this.config.record, // バリデーション目的だったが自由になったので棋譜コピー用だけのためにある
      edit_mode_sfen:  null,               // 編集モードでの棋譜
    }
  },
  provide() {
    return {
      SB: this,
    }
  },
  beforeMount() {
    this.$debug.trace("SbApp", "beforeMount")
  },
  mounted() {
    // console.log(this.$route)
    this.$debug.trace("SbApp", "mounted")

    // this.$nuxt.error({statusCode: 500, message: "xxx"})
    // return

    if (this.AppConfig.WATCH_AND_URL_REPLACE) {
      // どれかが変更されたらURLを更新
      this.$watch(() => [
        this.sp_mode,
        this.current_sfen,
        this.current_turn,
        this.current_title,
        this.viewpoint,
        this.room_key,
        this.color_theme_key,
      ], () => {
        // 両方エラーになってしまう
        //   this.$router.replace({name: "share-board", query: this.current_url_params})
        //   this.$router.replace({query: this.current_url_params})
        // パラメータだけ変更するときは変更してくれるけどエラーになるっぽいのでエラーにぎりつぶす(いいのか？)
        this.$router.replace({query: this.current_url_params}).catch(e => {})
      })
    }

    this.autoexec()
  },

  // http://localhost:4000/share-board?autoexec=general_setting_modal_open_handle
  // http://localhost:4000/share-board?autoexec=is_debug_mode_on,general_setting_modal_open_handle
  methods: {
    current_title_set(title) {
      title = _.trim(title)
      if (this.current_title != title) {
        this.current_title = title
        this.title_share()
      }
    },

    // 盤面のみ最初の状態に戻す
    reset_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.current_sfen = this.config.record.sfen_body        // 渡している棋譜
      this.current_turn = this.config.record.initial_turn     // 現在の手数
      this.toast_ok("局面をいっちばん最初にここに来たときの状態に戻しました")
    },

  },

  computed: {
    TheSelf()        { return this },
    FormatTypeInfo() { return FormatTypeInfo },
    AppConfig()      { return AppConfig },

    ////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////

    // いちばん外側に設定するタグのstyleでグローバル的なものを指定する
    component_style() {
      return {
        "--board_width": this.board_width,
        ...this.appearance_theme_info.to_style,
      }
    },

    // いちばん外側に設定するタグのclassでグローバル的なものを指定する
    component_class() {
      const hv = {}
      hv.debug_mode_p        = this.debug_mode_p
      hv.order_enable_p      = this.order_enable_p
      hv.current_turn_self_p = this.current_turn_self_p
      hv.edit_mode_p         = this.edit_mode_p
      hv.normal_mode_p       = !this.edit_mode_p
      return [hv, this.appearance_theme_key]
    },
  },
}
</script>

<style lang="sass">
@import "./sass/support.sass"
@import "./appearance_theme/appearance_theme.sass"
@import "./sass/layout.sass"
@import "./sass/main.sass"
@import "./sass/gap.sass"
@import "./sass/SideColumn.sass"
</style>
