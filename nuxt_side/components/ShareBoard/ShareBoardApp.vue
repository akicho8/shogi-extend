<template lang="pug">
client-only
  .ShareBoardApp(:style="component_style" :class="component_class")
    | {{__trace__('ShareBoardApp', 'render')}}
    div(is="style" v-text="component_raw_css" v-if="avatar_king_info.key === 'is_avatar_king_on'")
    DebugBox.is-hidden-mobile(v-if="development_p")
      p g_howl_play_mode_key: {{g_howl_play_mode_key}}
      p watching_member_count: {{watching_member_count}}
      p os_change: {{os_change}}
      p order_enable_p: {{order_enable_p}}

      p avatars_hash: {{avatars_hash}}

      p time_limit_modal_instance: {{!!time_limit_modal_instance}}
      p cc_auto_time_limit_delay_id: {{cc_auto_time_limit_delay_id}}

      p current_xmatch_rule_key: {{current_xmatch_rule_key}}
      p self_vs_self_p: {{self_vs_self_p}}
      p ordered_members: {{ordered_members}}

      template(v-if="clock_box")
        p rest: {{clock_box.current.rest}}
        p next_location: {{next_location.key}}
        p timer: {{clock_box.timer}}
        p running_p: {{clock_box.running_p}}
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

    ShareBoardSidebar(:base="base")
    ShareBoardNavbar(:base="base")

    MainSection.is_mobile_padding_zero(v-if="room_creating_busy === 0")
      .container.is-fluid
        .columns.is-centered
          ShareBoardSp(:base="base" ref="ShareBoardSp")
          ShareBoardActionLog(:base="base" ref="ShareBoardActionLog")
          ShareBoardMemberList(:base="base")
        ShareBoardDebugPanels(:base="base" v-if="debug_mode_p")
</template>

<script>
import _ from "lodash"

import { FormatTypeInfo           } from "@/components/models/format_type_info.js"
import { autoexec_methods         } from "@/components/models/autoexec_methods.js"
import { Location                 } from "shogi-player/components/models/location.js"

import { support_parent           } from "./support_parent.js"

import { app_action_log           } from "./app_action_log.js"
import { app_message_logs         } from "./app_message_logs.js"
import { app_clock_box            } from "./app_clock_box.js"
import { app_clock_box_time_limit } from "./app_clock_box_time_limit.js"
import { app_persistent_cc_params } from "./app_persistent_cc_params.js"
import { app_turn_notify          } from "./app_turn_notify.js"
import { app_ordered_members      } from "./app_ordered_members.js"
import { app_chore                } from "./app_chore.js"
import { app_avatar               } from "./app_avatar.js"
import { app_guardian             } from "./app_guardian.js"
import { app_handle_name          } from "./app_handle_name.js"
import { app_member_info_modal    } from "./app_member_info_modal.js"
import { app_urls                 } from "./app_urls.js"
import { app_edit_mode            } from "./app_edit_mode.js"
import { app_sp                   } from "./app_sp.js"
import { app_room_setup           } from "./app_room_setup.js"
import { app_devise               } from "./app_devise.js"
import { app_room_leave           } from "./app_room_leave.js"
import { app_track_log            } from "./app_track_log.js"
import { app_xmatch               } from "./app_xmatch.js"
import { app_room_board_setup     } from "./app_room_board_setup.js"
import { app_room_active_level    } from "./app_room_active_level.js"
import { app_room_members         } from "./app_room_members.js"
import { app_net_level            } from "./app_net_level.js"
import { app_ping                 } from "./app_ping.js"
import { app_tweet                } from "./app_tweet.js"
import { app_image_dl             } from "./app_image_dl.js"
import { app_update               } from "./app_update.js"
import { app_message              } from "./app_message.js"
import { app_main_setting         } from "./app_main_setting.js"
import { app_help                 } from "./app_help.js"
import { app_sidebar              } from "./app_sidebar.js"
import { app_user_name            } from "./app_user_name.js"
import { app_storage              } from "./app_storage.js"
import { app_export               } from "./app_export.js"
import { app_color_theme          } from "./app_color_theme.js"
import { app_sfen_share           } from "./app_sfen_share.js"
import { app_sfen_share_retry     } from "./app_sfen_share_retry.js"
import { app_force_sync           } from "./app_force_sync.js"
import { app_board_preset_select  } from "./app_board_preset_select.js"
import { app_room_recreate        } from "./app_room_recreate.js"
import { app_back_to              } from "./app_back_to.js"
import { window_active_detector   } from "./window_active_detector.js"

export default {
  name: "ShareBoardApp",
  mixins: [
    // どう見ても mixins の使い方を間違えている
    support_parent,
    autoexec_methods,
    app_action_log,
    app_message_logs,
    app_clock_box,
    app_clock_box_time_limit,
    app_persistent_cc_params,
    app_turn_notify,
    app_ordered_members,
    app_chore,
    app_avatar,
    app_guardian,
    app_handle_name,
    app_member_info_modal,
    app_urls,
    app_edit_mode,
    app_sp,
    app_room_setup,
    app_devise,
    app_room_leave,
    app_track_log,
    app_xmatch,
    app_room_board_setup,
    app_room_active_level,
    app_room_members,
    app_net_level,
    app_ping,
    app_tweet,
    app_image_dl,
    app_update,
    app_message,
    app_main_setting,
    app_help,
    app_sidebar,
    app_user_name,
    app_storage,
    app_export,
    app_color_theme,
    app_sfen_share,
    app_sfen_share_retry,
    app_force_sync,
    app_board_preset_select,
    app_room_recreate,
    app_back_to,
    window_active_detector,
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
      current_title:      this.config.record.title,              // 現在のタイトル
      current_turn:       this.config.record.initial_turn,       // 現在の手数
      abstract_viewpoint: this.config.record.abstract_viewpoint, // Twitter画像の向き

      // urlには反映しない
      sp_viewpoint: this.config.record.board_viewpoint, // 反転用
      turn_offset_max: null,                            // 最後の手数

      record:          this.config.record, // バリデーション目的だったが自由になったので棋譜コピー用だけのためにある
      edit_mode_sfen:  null,             // 編集モードでの棋譜
    }
  },
  beforeMount() {
    this.__trace__("ShareBoardApp", "beforeMount")
  },
  mounted() {
    this.__trace__("ShareBoardApp", "mounted")

    // this.$nuxt.error({statusCode: 500, message: "xxx"})
    // return

    // どれかが変更されたらURLを更新
    this.$watch(() => [
      this.sp_run_mode,
      this.sp_internal_rule_key,
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

    this.autoexec()
  },

  // http://localhost:4000/share-board?autoexec=general_setting_modal_handle
  // http://localhost:4000/share-board?autoexec=is_debug_mode_on,general_setting_modal_handle
  methods: {
    current_title_set(title) {
      title = _.trim(title)
      if (this.current_title != title) {
        this.current_title = title
        this.title_share(this.current_title)
      }
    },

    // ../../../app/controllers/share_boards_controller.rb の current_og_image_path と一致させること
    // AbstractViewpointKeySelectModal から新しい abstract_viewpoint が渡されるので params で上書きする
    permalink_for(params = {}) {
      return this.permalink_from_params({...this.current_url_params, ...params})
    },

    permalink_from_params(params = {}) {
      let url = null
      if (params.format) {
        url = new URL(this.$config.MY_SITE_URL + `/share-board.${params.format}`)
      } else {
        url = new URL(this.$config.MY_SITE_URL + `/share-board`)
      }
      _.each(params, (v, k) => {
        if (k !== "format") {
          if (v || true) {              // if (v) にしてしまうと turn = 0 のとき turn=0 が URL に含まれない
            url.searchParams.set(k, v)
          }
        }
      })
      return url.toString()
    },

    // 盤面のみ最初の状態に戻す
    reset_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.current_sfen = this.config.record.sfen_body        // 渡している棋譜
      this.current_turn  = this.config.record.initial_turn     // 現在の手数
      this.toast_ok("局面をいっちばん最初にここに来たときの状態に戻しました")
    },


  },

  computed: {
    base()           { return this },
    FormatTypeInfo() { return FormatTypeInfo },

    page_title() {
      if (this.current_turn === 0) {
        return this.current_title
      } else {
        return `${this.current_title} ${this.current_turn}手目`
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    current_xtitle() { return { title: this.current_title } },

    component_style() {
      return {
        "--board_width": this.board_width,
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    component_class() {
      const hv = {}
      hv.debug_mode_p        = this.debug_mode_p
      hv.order_enable_p      = this.order_enable_p
      hv.current_turn_self_p = this.current_turn_self_p
      return hv
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardApp.debug_mode_p
  .CustomShogiPlayer
  .ShogiPlayerGround
  .ShogiPlayerWidth
  .Membership
  .columns, .column
    border: 1px dashed change_color($success, $alpha: 0.5)

.ShareBoardApp
  .MainSection.section
    +mobile
      padding: 0.75rem 0 0
    +tablet-only
      padding: 1.5rem
      .container
        padding: 0
    +desktop
      padding: 2.25rem
      .container
        padding: 0

  +tablet
    .ShareBoardMemberList
      order: 1
    .ShareBoardSp
      order: 2
    .ShareBoardActionLog
      order: 3
  +mobile
    .ShareBoardActionLog
      margin-top: 1rem
    .ShareBoardMemberList
      margin-top: 1rem
</style>
