<template lang="pug">
client-only
  .SbApp(:style="component_style" :class="component_class")
    | {{$debug.trace('SbApp', 'render')}}
    DebugBox.is-hidden-mobile(v-if="development_p")
      p new_v.os_dnd_count: {{new_v.os_dnd_count}}
      p appearance_theme_key: {{appearance_theme_key}}
      p watching_member_count: {{watching_member_count}}
      p order_enable_p: {{order_enable_p}}

      p timeout_modal_instance: {{!!timeout_modal_instance}}
      p cc_auto_timeout_delay_id: {{cc_auto_timeout_delay_id}}

      p current_xmatch_rule_key: {{current_xmatch_rule_key}}
      p self_vs_self_p: {{self_vs_self_p}}

      template(v-if="clock_box")
        p rest: {{clock_box.current.rest}}
        p next_location: {{next_location.key}}
        p timer: {{clock_box.timer}}
        p pause_or_play_p: {{clock_box.pause_or_play_p}}
      p send_success_p={{send_success_p}}
      p x_retry_count={{x_retry_count}}
      p sequence_codes={{sequence_codes}}
      p $route.query: {{$route.query}}
      p sp_human_side: {{sp_human_side}}
      p current_turn_self_p: {{current_turn_self_p}}
      p current_turn_user_name: {{current_turn_user_name}}
      p current_turn: {{current_turn}}
      p sp_viewpoint: {{sp_viewpoint}}
      p sp_player_info: {{JSON.stringify(sp_player_info)}}
      //- p room_code: {{JSON.stringify(room_code)}}
      //- p user_name: {{JSON.stringify(user_name)}}
      //- p 人数: {{JSON.stringify(member_infos.length)}}
      //- p 手数: {{current_turn}} / {{turn_offset_max}}
      //- p SFEN: {{current_sfen}}
      //- p タイトル: {{current_title}}
      //- p 視点: {{abstract_viewpoint}}
      //- p モード: {{sp_run_mode}}
      //- p 視点: {{sp_viewpoint}}
      //- p URL: {{current_url}}
      //- p サイドバー {{sidebar_p}}

    SbSidebar(:base="base")
    SbNavbar

    MainSection.is_mobile_padding_zero(v-if="room_creating_busy === 0")
      .container.is-fluid
        //- .is-desktop でデスクトップ以上のときだけ横並びになる
        .columns.is-centered.is-desktop.is-variable.is-0
          SbSp(:base="base" ref="SbSp")
          SbMemberList
          SbActionLog(:base="base" ref="SbActionLog")
        SbDebugPanels(:base="base" v-if="debug_mode_p")
</template>

<script>
import _ from "lodash"

import { Location                 } from "shogi-player/components/models/location.js"

import { FormatTypeInfo           } from "@/components/models/format_type_info.js"
import { autoexec_methods         } from "@/components/models/autoexec_methods.js"

import { AppConfig                } from "./models/app_config.js"

import { support_parent           } from "./support_parent.js"

import { app_xtitle               } from "./app_xtitle.js"
import { app_action_log           } from "./action_log/app_action_log.js"
import { app_persistent_cc_params } from "./app_persistent_cc_params.js"
import { app_turn_notify          } from "./app_turn_notify.js"
import { app_otasuke              } from "./app_otasuke.js"
import { app_order_main           } from "./order_mod/app_order_main.js"
import { app_battle_session       } from "./app_battle_session.js"
import { app_chore                } from "./app_chore.js"
import { app_guardian             } from "./app_guardian.js"
import { app_handle_name          } from "./app_handle_name.js"
import { app_urls                 } from "./app_urls.js"
import { app_edit_mode            } from "./app_edit_mode.js"
import { app_yomikomi             } from "./app_yomikomi.js"
import { app_sp                   } from "./app_sp.js"
import { app_room_setup           } from "./app_room_setup.js"
import { app_devise               } from "./app_devise.js"
import { app_room_leave           } from "./app_room_leave.js"
import { app_user_kill            } from "./app_user_kill.js"
import { app_track_log            } from "./app_track_log.js"
import { app_xmatch               } from "./auto_matching/app_xmatch.js"
import { app_room_board_setup     } from "./app_room_board_setup.js"
import { app_room_active_level    } from "./app_room_active_level.js"
import { app_room_members         } from "./app_room_members.js"
import { app_member_bc            } from "./app_member_bc.js"
import { app_image_dl             } from "./app_image_dl.js"
import { app_update               } from "./app_update.js"
import { app_sound_bug            } from "./app_sound_bug.js"
import { app_sound_effect         } from "./app_sound_effect.js"
import { app_main_setting         } from "./app_main_setting.js"
import { app_debug                } from "./app_debug.js"
import { app_sound_resume         } from "./app_sound_resume.js"
import { app_help                 } from "./help_mod/app_help.js"
import { app_sidebar              } from "./app_sidebar.js"
import { app_user_name            } from "./app_user_name.js"
import { app_storage              } from "./app_storage.js"
import { app_export               } from "./app_export.js"
import { app_player_names         } from "./app_player_names.js"
import { app_color_theme          } from "./app_color_theme.js"
import { app_sfen_share           } from "./app_sfen_share.js"
import { app_sfen_share_retry     } from "./app_sfen_share_retry.js"
import { app_force_sync           } from "./app_force_sync.js"
import { app_foul                 } from "./app_foul.js"
import { app_board_preset_select  } from "./app_board_preset_select.js"
import { app_room_recreate        } from "./app_room_recreate.js"
import { app_back_to              } from "./app_back_to.js"
import { window_active_detector   } from "./window_active_detector.js"

import { app_member_list          } from "./member_list_show/app_member_list.js"
import { app_member_info_modal    } from "./member_list_show/app_member_info_modal.js"
import { app_ping                 } from "./member_list_show/app_ping.js"
import { app_net_level            } from "./member_list_show/app_net_level.js"

import { app_message      } from "./chat/app_message.js"
import { app_message_logs } from "./chat/app_message_logs.js"

import { app_console      } from "./console/app_console.js"

import { app_clock_box         } from "./clock/app_clock_box.js"
import { app_clock_box_timeout } from "./clock/app_clock_box_timeout.js"
import { app_clock_decorator   } from "./clock/app_clock_decorator.js"

import { app_toryo     } from "./toryo/app_toryo.js"
import { app_honpu     } from "./toryo/app_honpu.js"
import { app_kifu_mail } from "./toryo/app_kifu_mail.js"

import { app_medal      } from "./medal/app_medal.js"
import { app_medal_plus } from "./medal/app_medal_plus.js"

import { app_appearance_theme } from "./appearance_theme/app_appearance_theme.js"

import { app_tweet } from "./tweet/app_tweet.js"

export default {
  name: "SbApp",
  mixins: [
    // どう見ても mixins の使い方を間違えている
    support_parent,
    autoexec_methods,
    app_xtitle,
    app_action_log,
    app_message,
    app_message_logs,
    app_console,
    app_persistent_cc_params,
    app_turn_notify,
    app_otasuke,
    app_order_main,
    app_member_list,
    app_battle_session,
    app_chore,
    app_kifu_mail,
    app_guardian,
    app_handle_name,
    app_member_info_modal,
    app_urls,
    app_edit_mode,
    app_yomikomi,
    app_sp,
    app_room_setup,
    app_devise,
    app_room_leave,
    app_user_kill,
    app_track_log,
    app_xmatch,
    app_room_board_setup,
    app_room_active_level,
    app_room_members,
    app_member_bc,
    app_net_level,
    app_ping,
    app_tweet,
    app_image_dl,
    app_update,
    app_sound_bug,
    app_sound_effect,
    app_main_setting,
    app_debug,
    app_sound_resume,
    app_help,
    app_sidebar,
    app_user_name,
    app_storage,
    app_export,
    app_player_names,
    app_color_theme,
    app_appearance_theme,
    app_sfen_share,
    app_sfen_share_retry,
    app_force_sync,
    app_foul,
    app_board_preset_select,
    app_room_recreate,
    app_back_to,
    app_toryo,
    app_honpu,
    app_medal,
    app_medal_plus,
    window_active_detector,

    // clock
    app_clock_box,
    app_clock_box_timeout,
    app_clock_decorator,
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
      current_sfen:       this.config.record.sfen_body,          // 渡している棋譜
      current_turn:       this.config.record.initial_turn,       // 現在の手数
      abstract_viewpoint: this.config.record.abstract_viewpoint, // Twitter画像の向き

      // urlには反映しない
      sp_viewpoint: this.config.record.board_viewpoint, // 反転用
      turn_offset_max: null,                            // 最後の手数

      record:          this.config.record, // バリデーション目的だったが自由になったので棋譜コピー用だけのためにある
      edit_mode_sfen:  null,               // 編集モードでの棋譜
    }
  },
  provide() {
    return {
      TheSb: this,
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
        this.sp_run_mode,
        this.current_sfen,
        this.current_turn,
        this.current_title,
        this.abstract_viewpoint,
        this.room_code,
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

  // http://localhost:4000/share-board?autoexec=general_setting_modal_handle
  // http://localhost:4000/share-board?autoexec=is_debug_mode_on,general_setting_modal_handle
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
    base()           { return this },
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
@import "./support.sass"
@import "./appearance_theme/appearance_theme.sass"
@import "./layout.sass"
@import "./gap.sass"
@import "./SideColumn.sass"
</style>
