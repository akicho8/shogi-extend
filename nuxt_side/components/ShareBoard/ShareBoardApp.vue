<template lang="pug">
client-only
  .ShareBoardApp(:style="component_style")
    | {{__trace__('ShareBoardApp', 'render')}}
    div(is="style" v-text="component_raw_css" v-if="avatar_king_info.key === 'is_avatar_king_on'")
    DebugBox.is-hidden-mobile(v-if="development_p")
      p watching_member_count: {{watching_member_count}}
      p os_change: {{os_change}}
      p order_func_p: {{order_func_p}}

      p avatars_hash: {{avatars_hash}}

      p time_limit_modal_instance: {{!!time_limit_modal_instance}}
      p cc_auto_time_limit_delay_id: {{cc_auto_time_limit_delay_id}}

      p current_xmatch_rule_key: {{current_xmatch_rule_key}}
      p self_vs_self_p: {{self_vs_self_p}}
      p ordered_members: {{ordered_members}}

      template(v-if="clock_box")
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
      p turn_offset: {{turn_offset}}
      p sp_viewpoint: {{sp_viewpoint}}
      p sp_player_info: {{JSON.stringify(sp_player_info)}}
      //- p room_code: {{JSON.stringify(room_code)}}
      //- p user_name: {{JSON.stringify(user_name)}}
      //- p 人数: {{JSON.stringify(member_infos.length)}}
      //- p 手数: {{turn_offset}} / {{turn_offset_max}}
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
          .MainColumn.column(:class="main_column_class")
            CustomShogiPlayer.is_mobile_vertical_good_style(
              ref="main_sp"
              :sp_layer="development_p ? 'is_layer_off' : 'is_layer_off'"
              :sp_run_mode="sp_run_mode"
              :sp_turn="turn_offset"
              :sp_body="current_sfen"
              :sp_sound_enabled="true"
              :sp_viewpoint.sync="sp_viewpoint"
              :sp_player_info="sp_player_info"
              :sp_human_side="sp_human_side"
              :sp_controller="controller_disabled_p ? 'is_controller_off' : 'is_controller_on'"
              :sp_slider="controller_disabled_p ? 'is_slider_off' : 'is_slider_on'"

              sp_debug_mode="is_debug_mode_off"
              sp_summary="is_summary_off"

              :sp_play_mode_legal_move_only="strict_p"
              :sp_play_mode_only_own_piece_to_move="strict_p"
              :sp_play_mode_can_not_kill_same_team_soldier="strict_p"

              :sp_move_cancel="sp_move_cancel_info.key"

              @update:play_mode_advanced_full_moves_sfen="play_mode_advanced_full_moves_sfen_set"
              @update:edit_mode_snapshot_sfen="edit_mode_snapshot_sfen_set"
              @update:mediator_snapshot_sfen="mediator_snapshot_sfen_set"
              @update:turn_offset="v => turn_offset = v"
              @update:turn_offset_max="v => turn_offset_max = v"
              @operation_invalid1="operation_invalid1_handle"
              @operation_invalid2="operation_invalid2_handle"
            )

            .footer_buttons(v-if="edit_mode_p")
              .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
                b-button(@click="king_formation_auto_set(true)") 詰将棋検討用玉配置
                b-button(@click="king_formation_auto_set(false)") 玉回収

              .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
                PiyoShogiButton(:href="piyo_shogi_app_with_params_url")
                KentoButton(tag="a" :href="kento_app_with_params_url" target="_blank")
                KifCopyButton(@click="kifu_copy_handle('kif')") コピー

              .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
                b-button(@click="base.any_source_read_handle") 棋譜の読み込み

            .buttons.is-centered.mt-4(v-if="true")
              //- b-tooltip(label="ツイート")
              //- TweetButton(size="" :body="tweet_body" :type="advanced_p ? 'is-twitter' : ''" v-if="play_mode_p")
              b-button.has-text-weight-bold(:type="advanced_p ? 'is-twitter' : ''" v-if="tweet_button_show_p" icon-left="twitter" @click="tweet_modal_handle") ツイート

              //- b-button.has-text-weight-bold(type="is-primary" @click="play_mode_handle" v-if="edit_mode_p") 編集完了

            .room_code.is-clickable(@click="room_setup_modal_handle" v-if="false")
              | {{room_code}}

          ShareBoardActionLog(:base="base" ref="ShareBoardActionLog" v-if="ac_room")
          ShareBoardMemberList(:base="base" v-if="ac_room")

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
import { app_member_info_modal         } from "./app_member_info_modal.js"
import { app_urls                 } from "./app_urls.js"
import { app_edit_mode            } from "./app_edit_mode.js"
import { app_room_setup           } from "./app_room_setup.js"
import { app_devise               } from "./app_devise.js"
import { app_room_leave           } from "./app_room_leave.js"
import { app_track_log            } from "./app_track_log.js"
import { app_xmatch               } from "./app_xmatch.js"
import { app_room_board_setup     } from "./app_room_board_setup.js"
import { app_room_active_level    } from "./app_room_active_level.js"
import { app_room_members         } from "./app_room_members.js"
import { app_net_level           } from "./app_net_level.js"
import { app_ping                 } from "./app_ping.js"
import { app_tweet                } from "./app_tweet.js"
import { app_image_dl                } from "./app_image_dl.js"
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
import { app_board_preset_select         } from "./app_board_preset_select.js"
import { app_room_recreate        } from "./app_room_recreate.js"
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
      turn_offset:        this.config.record.initial_turn,       // 現在の手数
      abstract_viewpoint: this.config.record.abstract_viewpoint, // Twitter画像の向き

      // urlには反映しない
      sp_viewpoint: this.config.record.board_viewpoint, // 反転用
      turn_offset_max: null,                            // 最後の手数

      record:        this.config.record, // バリデーション目的だったが自由になったので棋譜コピー用だけのためにある
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
      this.turn_offset,
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
    // internal_rule_input_handle() {
    //   this.sound_play_click()
    // },

    // 再生モードで指したときmovesあり棋譜(URLに反映する)
    // 局面0で1手指したとき last_move_info.next_turn_offset は 1
    play_mode_advanced_full_moves_sfen_set(e) {
      this.current_sfen = e.sfen

      // this.sound_play("shout_08")
      this.vibrate(10)

      // 時計があれば操作した側のボタンを押す
      // last_move_info.player_location なら指した人の色で判定
      // last_move_info.to_location なら駒の色で判定
      if (this.clock_box) {
        this.clock_box.tap_on(e.last_move_info.player_location)
      }

      this.sfen_share_params_set(e.last_move_info) // 再送用可能なパラメータ作成
      this.sfen_share()                            // 指し手と時計状態の配信

      // 次の人の視点にする
      if (false) {
        const location = this.current_sfen_info.location_by_offset(e.last_move_info.next_turn_offset)
        this.sp_viewpoint = location.key
      }
    },

    // デバッグ用
    mediator_snapshot_sfen_set(sfen) {
      if (this.development_p) {
        // this.$buefy.toast.open({message: `mediator_snapshot_sfen -> ${sfen}`, queue: false})
      }
    },

    // 編集モード時の局面
    // ・常に更新するが、URLにはすぐには反映しない→やっぱり反映する
    // ・あとで current_sfen に設定する
    // ・すぐに反映しないのは駒箱が消えてしまうから
    edit_mode_snapshot_sfen_set(v) {
      this.__assert__(this.sp_run_mode === "edit_mode", 'this.sp_run_mode === "edit_mode"')

      // NOTE: current_sfen に設定すると(current_sfenは駒箱を持っていないため)駒箱が消える
      // edit_modeの完了後に edit_mode_sfen を current_sfen に戻す
      this.edit_mode_sfen = v

      // 意図せず共有してしまうのを防ぐため共有しない
      // if (false) {
      //   this.sfen_share_params_set()
      // }
      // }
    },

    // private

    // url_replace() {
    //   this.$router.replace({query: this.current_url_params})
    // },

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
      this.turn_offset  = this.config.record.initial_turn     // 現在の手数
      this.toast_ok("局面をいっちばん最初にここに来たときの状態に戻しました")
    },

    operation_invalid1_handle() {
      if (this.base.order_func_p) {
        if (this.base.ordered_members) {
          this.sound_play("x")
          const name = this.current_turn_user_name
          if (name) {
            this.toast_ok(`今は${this.user_call_name(name)}の手番です`)
          } else {
            this.toast_ok(`順番設定で対局者の指定がないので誰も操作できません`)
          }
        }
      }
    },
    operation_invalid2_handle() {
      this.sound_play("x")
      if (this.development_p) {
        this.toast_ok("それは相手の駒です")
      }
    },
  },

  computed: {
    base()           { return this },
    FormatTypeInfo() { return FormatTypeInfo },

    play_mode_p() { return this.sp_run_mode === 'play_mode' },
    edit_mode_p() { return this.sp_run_mode === 'edit_mode' },

    advanced_p()  { return this.turn_offset > this.config.record.initial_turn }, // 最初に表示した手数より進めたか？

    page_title() {
      if (this.turn_offset === 0) {
        return this.current_title
      } else {
        return `${this.current_title} ${this.turn_offset}手目`
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    current_sfen_attrs() {
      return {
        sfen:              this.current_sfen,
        turn_offset:       this.current_sfen_info.turn_offset_max, // これを入れない方が早い？
        last_location_key: this.current_sfen_info.last_location.key,
      }
    },
    current_sfen_info()            { return this.sfen_parse(this.current_sfen)                          },
    current_sfen_turn_offset_max() { return this.current_sfen_info.turn_offset_max                      },
    next_location()                { return this.current_sfen_info.next_location                        },
    current_location()             { return this.current_sfen_info.location_by_offset(this.turn_offset) },
    base_location()                { return this.current_sfen_info.location_by_offset(0)                },

    component_style() {
      return {
        "--board_width": this.board_width,
      }
    },

    main_column_class() {
      return [
        `is_sb_${this.sp_run_mode}`, // is_sb_play_mode, is_sb_edit_mode
      ]
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 将棋盤の下のコントローラーを表示しない条件
    // 対局時計が設置されていて STOP または PAUSE 状態のとき
    controller_disabled_p() {
      // if (this.development_p) {
      //   return false
      // }

      if (this.ctrl_mode_info.key === "is_ctrl_mode_hidden") {
        if (this.clock_box) {
          return this.clock_box.working_p
        }
      }
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.STAGE-development
  .ShareBoardApp
    .CustomShogiPlayer
    .ShogiPlayerGround
    .ShogiPlayerWidth
    .Membership
    .columns, .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.ShareBoardApp
  .navbar-end

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

  .EditToolBlock
    // margin-top: 12px

  // .MainColumn
  //   +tablet
  //     padding-top: 0
  //     padding-bottom: 0

  .footer_buttons
    .button
      margin-bottom: 0

  ////////////////////////////////////////////////////////////////////////////////
  .MainColumn
    +tablet
      padding-top: unset
      padding-bottom: unset
      &.is_sb_play_mode
        max-width: calc(var(--board_width) * 1.0vmin)
      &.is_sb_edit_mode
        max-width: calc(var(--board_width) * 1.0vmin * 0.75)
  ////////////////////////////////////////////////////////////////////////////////

  +tablet
    .ShareBoardMemberList
      order: 1
    .MainColumn
      order: 2
    .ShareBoardActionLog
      order: 3
  +mobile
    .ShareBoardActionLog
      margin-top: 1rem
    .ShareBoardMemberList
      margin-top: 1rem

  .CustomShogiPlayer
    .MembershipLocationPlayerInfo
      &.read_sec_60, &.extra_sec_60
        background-color: change_color($green, $saturation: 50%, $lightness: 80%) !important
        color: $black !important
      &.read_sec_20, &.extra_sec_20
        background-color: change_color($yellow, $saturation: 50%, $lightness: 80%) !important
        color: $black !important
      &.read_sec_10, &.extra_sec_10
        background-color: change_color($danger, $saturation: 50%, $lightness: 80%) !important
        color: $black !important

    // .PieceTexture
    //   .PieceTextureSelf
    //     &.location_black
    //     &.promoted_false
    //     &.piece_name
    //     &.piece_K
    //       background-image: url("/icon.png")
</style>
