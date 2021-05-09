<template lang="pug">
client-only
  .ShareBoardApp(:style="component_style")
    DebugBox(v-if="development_p")
      p send_success_p={{send_success_p}}
      p sequence_codes={{sequence_codes}}
      p $route.query: {{$route.query}}
      p sp_human_side: {{sp_human_side}}
      p current_turn_self_p: {{current_turn_self_p}}
      p current_turn_user_name: {{current_turn_user_name}}
      p turn_offset: {{turn_offset}}
      p previous_user_name: {{previous_user_name}}
      p ordered_members: {{ordered_members}}
      template(v-if="chess_clock")
        p next_location: {{next_location.key}}
        p timer: {{chess_clock.timer}}
        p running_p: {{chess_clock.running_p}}
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
              sp_summary="is_summary_off"
              sp_slider="is_slider_on"
              sp_controller="is_controller_on"

              :sp_play_mode_legal_move_only="strict_p"
              :sp_play_mode_only_own_piece_to_move="strict_p"
              :sp_play_mode_can_not_kill_same_team_soldier="strict_p"

              @update:play_mode_advanced_full_moves_sfen2="play_mode_advanced_full_moves_sfen2_set"
              @update:edit_mode_snapshot_sfen="edit_mode_snapshot_sfen_set"
              @update:mediator_snapshot_sfen="mediator_snapshot_sfen_set"
              @update:turn_offset="v => turn_offset = v"
              @update:turn_offset_max="v => turn_offset_max = v"
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

          ShareBoardActionLog(:base="base" ref="ShareBoardActionLog" v-if="present_p(room_code)")
          ShareBoardMemberList(:base="base" v-if="present_p(room_code)")

        .columns(v-if="development_p")
          .column.is-clipped
            ChessClockInspector(:chess_clock="chess_clock" v-if="chess_clock")

            .box
              .buttons
                b-button(@click="room_recreate") 再接続
                b-button(@click="room_create") 接続
                b-button(@click="room_destroy") 切断
                b-button(@click="member_info_bc_restart") 生存通知
                b-button(@click="al_add_test") 指
                b-button(@click="time_limit_modal_handle") 時間切れ
                b-button(@click="edit_warn_modal_handle") 編集警告
                b-button(@click="chess_clock_share('')") 時計同期
                b-button(@click="chess_clock_share()") 時計同期(message=null)
                b-button(@click="fake_error") エラー
                b-button(@click="reload_modal_handle") リロード確認

            .buttons
              b-button(tag="a" :href="json_debug_url") JSON
            .block
              b JS側で作った動的なTwitter画像URL(視点設定プレビューで使用する。Rails側と一致していること)
              p(:key="twitter_card_url") {{twitter_card_url}}
              img.is-block(:src="twitter_card_url" width="256")
            .block
              b Rails側で作った静的なTwitter画像URL(og:imageにはこっちを指定している)
              p {{config.twitter_card_options.image}}
              img.is-block(:src=`$config.MY_SITE_URL + config.twitter_card_options.image` width="256")
            .block
              b this.record
              pre {{JSON.stringify(record, null, 4)}}
  //- DebugPre(v-if="development_p") {{$data}}
</template>

<script>
const SHARE_BOARD_TITLE     = "共有将棋盤"
const RUN_MODE_DEFAULT      = "play_mode"
const INTERNAL_RULE_DEFAULT = "strict"

import _ from "lodash"

import { FormatTypeInfo } from "@/components/models/format_type_info.js"
import { Location       } from "shogi-player/components/models/location.js"

import { support_parent       } from "./support_parent.js"

import { app_action_log       } from "./app_action_log.js"
import { app_message_logs     } from "./app_message_logs.js"
import { app_chess_clock      } from "./app_chess_clock.js"
import { app_turn_notify      } from "./app_turn_notify.js"
import { app_ordered_members  } from "./app_ordered_members.js"
import { app_chore            } from "./app_chore.js"
import { app_edit_mode        } from "./app_edit_mode.js"
import { app_room_setup       } from "./app_room_setup.js"
import { app_track_log        } from "./app_track_log.js"
import { app_room_board_setup } from "./app_room_board_setup.js"
import { app_room_members     } from "./app_room_members.js"
import { app_ping             } from "./app_ping.js"
import { app_tweet            } from "./app_tweet.js"
import { app_update           } from "./app_update.js"
import { app_message          } from "./app_message.js"
import { app_sidebar          } from "./app_sidebar.js"
import { app_storage          } from "./app_storage.js"
import { app_export           } from "./app_export.js"
import { app_sfen_share       } from "./app_sfen_share.js"
import { app_force_sync       } from "./app_force_sync.js"
import { app_room_recreate    } from "./app_room_recreate.js"
import { window_active_check  } from "./window_active_check.js"

export default {
  name: "ShareBoardApp",
  mixins: [
    support_parent,
    app_action_log,
    app_message_logs,
    app_chess_clock,
    app_turn_notify,
    app_ordered_members,
    app_chore,
    app_edit_mode,
    app_room_setup,
    app_track_log,
    app_room_board_setup,
    app_room_members,
    app_ping,
    app_tweet,
    app_update,
    app_message,
    app_sidebar,
    app_storage,
    app_export,
    app_sfen_share,
    app_force_sync,
    app_room_recreate,
    window_active_check,
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
      sp_viewpoint: this.config.record.board_viewpoint,       // 反転用
      turn_offset_max: null,                         // 最後の手数

      record:        this.config.record, // バリデーション目的だったが自由になったので棋譜コピー用だけのためにある
      sp_run_mode:   this.defval(this.$route.query.sp_run_mode, RUN_MODE_DEFAULT),  // 操作モードと局面編集モードの切り替え用
      internal_rule: this.defval(this.$route.query.internal_rule, INTERNAL_RULE_DEFAULT),        // 操作モードの内部ルール strict or free

      share_board_column_width: 80, // 盤の大きさ
    }
  },
  mounted() {
    // this.$nuxt.error({statusCode: 500, message: "xxx"})
    // return

    // どれかが変更されたらURLを更新
    this.$watch(() => [
      this.sp_run_mode,
      this.internal_rule,
      this.current_sfen,
      this.turn_offset,
      this.current_title,
      this.abstract_viewpoint,
      this.room_code,
    ], () => {
      // 両方エラーになってしまう
      //   this.$router.replace({name: "share-board", query: this.current_url_params})
      //   this.$router.replace({query: this.current_url_params})
      // パラメータだけ変更するときは変更してくれるけどエラーになるっぽいのでエラーにぎりつぶす(いいのか？)
      this.$router.replace({query: this.current_url_params}).catch(e => {})
    })
  },
  methods: {
    internal_rule_input_handle() {
      this.sound_play("click")
    },

    // 再生モードで指したときmovesあり棋譜(URLに反映する)
    // 局面0で1手指したとき last_move_info.turn_offset は 1
    play_mode_advanced_full_moves_sfen2_set(sfen, last_move_info) {
      this.current_sfen = sfen
      this.sfen_share_params_set(last_move_info)
      this.sfen_share()

      // 時計があれば操作した側のボタンを押す
      // last_move_info.player_location なら指した人の色で判定
      // last_move_info.to_location なら駒の色で判定
      if (this.chess_clock) {
        this.cc_switch_handle(this.chess_clock.single_clocks[last_move_info.player_location.code])
      }

      // 時計の状態をブロードキャストする
      this.chess_clock_share("")
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
      if (this.sp_run_mode === "edit_mode") { // 操作モードでも呼ばれるから
        this.current_sfen = v
        // 意図せず共有してしまうのを防ぐため共有しない
        // if (false) {
        //   this.sfen_share_params_set()
        // }
      }
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
    permalink_for(params = {}) {
      let url = null
      if (params.format) {
        url = new URL(this.$config.MY_SITE_URL + `/share-board.${params.format}`)
      } else {
        url = new URL(this.$config.MY_SITE_URL + `/share-board`)
      }

      // AbstractViewpointKeySelectModal から新しい abstract_viewpoint が渡されるので params で上書きすること
      params = {
        ...this.current_url_params,
        ...params,
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
      this.sound_play("click")
      this.current_sfen = this.config.record.sfen_body        // 渡している棋譜
      this.turn_offset  = this.config.record.initial_turn     // 現在の手数
      this.toast_ok("局面をいっちばん最初にここに来たときの状態に戻しました")
    },
  },

  computed: {
    base()           { return this },
    FormatTypeInfo() { return FormatTypeInfo },

    play_mode_p()    { return this.sp_run_mode === 'play_mode' },
    edit_mode_p()    { return this.sp_run_mode === 'edit_mode' },
    strict_p()       { return this.internal_rule === "strict"  },
    advanced_p()     { return this.turn_offset > this.config.record.initial_turn }, // 最初に表示した手数より進めたか？

    page_title() {
      if (this.turn_offset === 0) {
        return this.current_title
      } else {
        return `${this.current_title} ${this.turn_offset}手目`
      }
    },

    current_url_params() {
      let params = {
        ...this.$route.query,                  // デバッグ用パラメータを保持するため
        body:               this.current_body, // 編集モードでもURLを更新するため
        turn:               this.turn_offset,
        title:              this.current_title,
        abstract_viewpoint: this.abstract_viewpoint,
        room_code:          this.room_code,
        sp_run_mode:        this.sp_run_mode,
        internal_rule:      this.internal_rule,
      }

      if (this.blank_p(params.title) || params.title === SHARE_BOARD_TITLE) {
        delete params.title
      }
      if (this.blank_p(params.room_code)) {
        delete params.room_code
      }
      if (params.sp_run_mode === RUN_MODE_DEFAULT) {
        delete params.sp_run_mode
      }
      if (params.internal_rule === INTERNAL_RULE_DEFAULT) {
        delete params.internal_rule
      }

      return params
    },

    // URL
    current_url()      { return this.permalink_for()                 },
    json_debug_url()   { return this.permalink_for({format: "json"}) },
    twitter_card_url() { return this.permalink_for({format: "png"})  },

    // 外部アプリ
    piyo_shogi_app_with_params_url() {
      return this.piyo_shogi_auto_url({
        path: this.current_url,
        sfen: this.current_sfen,
        turn: this.turn_offset,
        viewpoint: this.sp_viewpoint,
        game_name: this.current_title,
      })
    },

    kento_app_with_params_url() {
      return this.kento_full_url({
        sfen: this.current_sfen,
        turn: this.turn_offset,
        viewpoint: this.sp_viewpoint,
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////

    // 常に画面上の盤面と一致している
    current_body() { return this.current_sfen },

    component_style() {
      return {
        "--share_board_column_width": this.share_board_column_width,
      }
    },

    main_column_class() {
      return [
        `is_sb_${this.sp_run_mode}`, // is_sb_play_mode, is_sb_edit_mode
      ]
    },

    next_location() {
      return this.sfen_parse(this.current_sfen).next_location
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
        max-width: calc(var(--share_board_column_width) * 1.0vmin)
      &.is_sb_edit_mode
        max-width: calc(var(--share_board_column_width) * 1.0vmin * 0.75)
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
</style>
