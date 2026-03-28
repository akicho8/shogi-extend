<template lang="pug">
client-only
  .SbApp(:style="app_component_style" :class="app_component_class")
    div(is="style" v-text="app_component_raw_css" v-if="app_component_raw_css")
    | {{$debug.trace('SbApp', 'render')}}
    SbDebugVarPanel
    SbControlPanel
    SbTopNav
    SbBottomNav
    MainSection.is_mobile_padding_zero(v-if="!room_recreate_now")
      .container.is-fluid
        //- .is-desktop でデスクトップ以上のときだけ横並びになる
        .columns.is-centered.is-desktop.is-variable.is-0
          SbShogiPlayer(ref="SbShogiPlayer")
          SbMemberList
          XhistoryContainer(ref="XhistoryContainer")
        SbDebug(v-if="debug_mode_p")
</template>

<script>
import { GX } from "@/components/models/gx.js"
import _ from "lodash"

import { Location                 } from "shogi-player/components/models/location.js"

import { FormatTypeInfo           } from "@/components/models/format_type_info.js"
import { autoexec_methods         } from "@/components/models/autoexec_methods.js"

import { AppConfig                } from "./models/mod_app_config.js"

import { support_parent           } from "./support_parent.js"

import { mod_xtitle               } from "./mod_xtitle.js"

import { mod_xhistory             } from "./mod_xhistory/mod_xhistory.js"

import { mod_turn_notify          } from "./mod_turn_notify.js"
import { mod_xstatus              } from "./mod_xstatus/mod_xstatus.js"
import { mod_order_main           } from "./mod_order/mod_order_main.js"
import { mod_migrate              } from "./mod_migrate/mod_migrate.js"
import { mod_chore                } from "./mod_chore.js"
import { mod_avatar               } from "./mod_avatar/mod_avatar.js"
import { mod_handle_name          } from "./mod_handle_name/mod_handle_name.js"
import { mod_urls                 } from "./mod_urls.js"
import { mod_share_dto            } from "./mod_share_dto.js"
import { mod_edit_mode            } from "./mod_edit/mod_edit_mode.js"
import { mod_kifu_loader          } from "./mod_kifu_loader/mod_kifu_loader.js"
import { mod_shogi_player         } from "./mod_shogi_player/mod_shogi_player.js"
import { mod_warning              } from "./mod_warning.js"
import { mod_perpetual            } from "./mod_perpetual/mod_perpetual.js"
import { mod_think_mark           } from "./mod_think_mark/mod_think_mark.js"
import { mod_devise               } from "./mod_devise.js"
import { mod_user_kick            } from "./mod_user_kick.js"
import { mod_track_log            } from "./mod_track_log/mod_track_log.js"
import { mod_xmatch               } from "./mod_matching/mod_xmatch.js"
import { mod_member_bc            } from "./mod_member_bc.js"
import { mod_image_download       } from "./mod_image_download.js"
import { mod_app_update           } from "./mod_app_update.js"
import { mod_sfx                  } from "./mod_sfx/mod_sfx.js"
import { mod_general_setting      } from "./mod_general_setting/mod_general_setting.js"
import { mod_global_var           } from "./mod_global_var.js"
import { mod_debug                } from "./mod_debug.js"
import { mod_help                 } from "./mod_help/mod_help.js"
import { mod_control_panel        } from "./mod_control_panel/mod_control_panel.js"
import { mod_storage              } from "./mod_storage.js"
import { mod_export               } from "./mod_export.js"
import { mod_role                 } from "./mod_role/mod_role.js"
import { mod_color_theme          } from "./mod_color_theme.js"
import { mod_sfen_sync            } from "./mod_sfen_sync.js"
import { mod_resend               } from "./mod_resend/mod_resend.js"
import { mod_look_away            } from "./mod_look_away/mod_look_away.js"
import { mod_reflector            } from "./mod_reflector/mod_reflector.js"
import { mod_illegal              } from "./mod_illegal/mod_illegal.js"
import { mod_board_preset         } from "./mod_board_preset/mod_board_preset.js"
import { mod_shortcut             } from "./mod_shortcut/mod_shortcut.js"

import { mod_room                 } from "./mod_room/mod_room.js"

import { mod_member_profile       } from "./mod_member_profile/mod_member_profile.js"

import { mod_chat                 } from "./mod_chat/mod_chat.js"

import { mod_console              } from "./mod_console/mod_console.js"

import { mod_clock                } from "./mod_clock/mod_clock.js"

import { mod_resign               } from "./mod_resign/mod_resign.js"
import { mod_kifu_mailer          } from "./mod_resign/mod_kifu_mailer.js"
import { mod_battle_archive       } from "./mod_resign/mod_battle_archive.js"

import { mod_honpu                } from "./mod_honpu/mod_honpu.js"

import { mod_fes                 } from "./mod_fes/mod_fes.js"

import { mod_xprofile             } from "./mod_xprofile/mod_xprofile.js"
import { mod_xprofile_console     } from "./mod_xprofile/mod_xprofile_console.js"

import { mod_appearance           } from "./mod_appearance/mod_appearance.js"

import { mod_tweet                } from "./mod_tweet/mod_tweet.js"

import { mod_dashboard            } from "./mod_dashboard/mod_dashboard.js"

export default {
  name: "SbApp",
  mixins: [
    // どう見ても mixins の使い方を間違えている
    support_parent,
    autoexec_methods,
    mod_xtitle,

    mod_xhistory,

    mod_chat,

    mod_console,
    mod_turn_notify,
    mod_xstatus,
    mod_order_main,
    mod_migrate,
    mod_chore,
    mod_kifu_mailer,
    mod_battle_archive,
    mod_avatar,
    mod_handle_name,
    mod_urls,
    mod_share_dto,
    mod_edit_mode,
    mod_kifu_loader,
    mod_shogi_player,
    mod_warning,
    mod_perpetual,
    mod_think_mark,
    mod_devise,
    mod_user_kick,
    mod_track_log,
    mod_xmatch,
    mod_member_bc,
    mod_tweet,
    mod_dashboard,
    mod_image_download,
    mod_app_update,
    mod_sfx,
    mod_general_setting,
    mod_global_var,
    mod_debug,
    mod_help,
    mod_control_panel,
    mod_storage,
    mod_export,
    mod_role,
    mod_color_theme,
    mod_appearance,
    mod_sfen_sync,
    mod_resend,
    mod_look_away,
    mod_reflector,
    mod_illegal,
    mod_board_preset,
    mod_shortcut,
    mod_resign,
    mod_honpu,
    mod_xprofile,
    mod_xprofile_console,
    mod_room,
    mod_member_profile,
    mod_clock,
    mod_fes,
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
    this.$debug.trace("SbApp", "mounted")
    this.autoexec()
  },

  beforeDestroy() {
    if (this.debug_mode_p) {
      GX.assert(this.g_modal_instance_count === 0, "this.g_modal_instance_count === 0")
    }
  },

  computed: {
    TheSelf()        { return this },
    FormatTypeInfo() { return FormatTypeInfo },
    AppConfig()      { return AppConfig },
    Location()       { return Location },

    ////////////////////////////////////////////////////////////////////////////////

    // いちばん外側に設定するタグのstyleでグローバル的なものを指定する
    app_component_style() {
      return {
        "--sb_board_width": this.sb_board_width,
        "--sb_grid_stroke": this.sb_grid_stroke,
        ...this.appearance_theme_info.to_css_vars,
        ...this.pentagon_to_avatar_css_vars,
      }
    },

    // いちばん外側に設定するタグのclassでグローバル的なものを指定する
    app_component_class() {
      const hv = {}
      hv.debug_mode_p               = this.debug_mode_p
      hv.order_enable_p             = this.order_enable_p
      hv.current_turn_self_p        = this.current_turn_self_p
      hv.edit_mode_p                = this.edit_mode_p
      hv.play_mode_p                = this.play_mode_p
      hv.pentagon_to_avatar_finally_on = this.pentagon_to_avatar_finally_on
      hv[this.appearance_theme_info.key] = true
      hv[this.pentagon_appearance_info.key] = true
      hv.__SYSTEM_TEST_RUNNING__    = this.__SYSTEM_TEST_RUNNING__
      return hv
    },

    // いちばん外側に設定するCSS
    app_component_raw_css() {
      return [
        // this.pentagon_to_avatar_css_vars,
      ].join(" ").replace(/\s+/g, " ")
    },
  },
}
</script>

<style lang="sass">
@import "./sass/all.sass"
</style>
