<template lang="pug">
.SbSp.MainColumn.column(:class="main_column_class")
  CustomShogiPlayer(
    v-bind="sp_bind"
    v-on="sp_hook"
    :sp_viewpoint.sync="base.viewpoint"
  )

  .footer_buttons(v-if="base.edit_mode_p")

    .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
      b-button(@click="base.king_formation_auto_set(true)") 詰将棋検討用玉配置
      b-button(@click="base.king_formation_auto_set(false)") 玉回収

    .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
      PiyoShogiButton(:href="base.current_kifu_vo.piyo_url")
      KentoButton(tag="a" :href="base.current_kifu_vo.kento_url" target="_blank")
      KifCopyButton(@click="base.kifu_copy_handle(base.FormatTypeInfo.fetch('kif_utf8'))") コピー

    .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
      b-button(@click="base.yomikomi_modal_open_handle()") 棋譜の読み込み

  .buttons.is-centered.mt-4(v-if="development_p && false")
    b-button.has-text-weight-bold(
      v-if="base.tweet_button_show_p"
      :type="tweet_button_type"
      icon-left="twitter"
      @click="base.tweet_modal_handle"
      )
      | ツイート
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SbSp",
  mixins: [support_child],
  computed: {
    // .column に指定するクラス
    main_column_class() {
      const av = []
      av.push(`is_sb_mode_${this.base.sp_mode}`) // is_sb_mode_play, is_sb_mode_edit
      return av
    },

    // CustomShogiPlayer に全部渡す
    sp_bind() {
      const hv = {}
      hv.ref                         = "main_sp"
      hv["class"]                    = this.base.sp_class

      // ここ以降 hv.sp_* = でないとおかしいので注意
      hv.sp_mode                     = this.base.sp_mode
      hv.sp_turn                     = this.base.current_turn
      hv.sp_body                     = this.base.current_sfen
      hv.sp_player_info              = this.base.sp_player_info
      hv.sp_human_side               = this.base.sp_human_side
      hv.sp_legal_move_only          = this.base.legal_strict_p
      hv.sp_my_piece_only_move       = this.base.legal_strict_p
      hv.sp_my_piece_kill_disabled   = this.base.legal_strict_p
      hv.sp_lift_cancel_action       = this.base.lift_cancel_action_info.key
      hv.sp_layer                    = this.sp_layer
      hv.sp_controller               = this.sp_controller
      hv.sp_slider                   = this.sp_slider

      if (!this.base.edit_mode_p) {
        hv.sp_piece_variant = this.base.appearance_theme_info.sp_piece_variant
        hv.sp_board_variant = this.base.appearance_theme_info.sp_board_variant
      }

      if (this.base.order_enable_p || this.base.cc_play_p) {
        // 反則時の挙動
        hv.sp_illegal_validate = this.base.illegal_behavior_info.sp_illegal_validate
        hv.sp_illegal_cancel   = this.base.illegal_behavior_info.sp_illegal_cancel
      } else {
        // 検討中
        hv.sp_illegal_validate = true // 反則を検知する
        hv.sp_illegal_cancel   = true // が、キャンセルする
      }

      if (false) {
        hv.sp_board_variant = "wood_normal"
      }

      return hv
    },

    // 開発時だけレイヤーON
    sp_layer() {
      return this.development_p
    },

    // 対局中にコントローラーは隠す
    sp_controller() {
      if (this.base.controller_disabled_p) {
        return false
      } else {
        return true
      }
    },

    // 対局中はスライダーも隠す
    sp_slider() {
      if (this.base.controller_disabled_p) {
        return false
      } else {
        return true
      }
    },

    // 動作を受け取るやつら
    sp_hook() {
      const hv = {}
      hv["ev_play_mode_move"]              = this.base.ev_play_mode_move
      hv["ev_edit_mode_short_sfen_change"] = this.base.ev_edit_mode_short_sfen_change
      hv["ev_short_sfen_change"]           = this.base.ev_short_sfen_change
      hv["ev_turn_offset_change"]          = v => this.base.current_turn = v
      hv["ev_turn_offset_max_change"]      = v => this.base.turn_offset_max = v

      hv["ev_action_viewpoint_flip"]       = this.base.ev_action_viewpoint_flip // 意図して☗☖をタップして反転させたとき
      hv["ev_action_turn_change"]          = this.base.ev_action_turn_change    // スライダーを動かしたとき
      hv["ev_action_piece_lift"]           = this.base.ev_action_piece_lift     // 意図して持ち上げた
      hv["ev_action_piece_cancel"]         = this.base.ev_action_piece_cancel   // 意図してキャンセルした

      // 手番 or 先後違い系
      hv["ev_illegal_click_but_self_is_not_turn"] = this.base.ev_illegal_click_but_self_is_not_turn
      hv["ev_illegal_my_turn_but_oside_click"]    = this.base.ev_illegal_my_turn_but_oside_click

      // 反則系
      hv["ev_illegal_illegal_accident"] = this.base.ev_illegal_illegal_accident

      return hv
    },

    tweet_button_type() {
      if (this.base.advanced_p) {
        return "is-twitter"
      }
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
@import "shogi-player/components/support.sass"

.SbSp
  +padding_lr(unset)

  // デスクトップ以上では大きさは動的に変更できる
  +desktop
    +padding_tb(unset)
    &.is_sb_mode_play
      max-width: calc(var(--board_width) * 1.0vmin)
    &.is_sb_mode_edit
      max-width: calc(var(--board_width) * 1.0vmin * 0.75)

  // 残り時間の色
  .CustomShogiPlayer
    .MembershipLocationPlayerInfo
      &.read_sec_60, &.extra_sec_60
        background-color: $white
        color: $black !important
      &.read_sec_20, &.extra_sec_20
        background-color: change_color($yellow, $saturation: 50%, $lightness: 80%) !important
        color: $black !important
      &.read_sec_10, &.extra_sec_10
        background-color: change_color($danger, $saturation: 50%, $lightness: 80%) !important
        color: $black !important

  .footer_buttons
    .button
      margin-bottom: 0

  // 名前で横幅を取ってしまうと持駒がはみでるので3文字までにする
  .ShogiPlayerGround
    +IF_VERTICAL
      .MembershipLocationPlayerInfoName
        +mobile
          max-width: 3em
          white-space: nowrap
          overflow: hidden
</style>
