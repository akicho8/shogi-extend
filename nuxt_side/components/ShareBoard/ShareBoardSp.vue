<template lang="pug">
.ShareBoardSp.MainColumn.column(:class="main_column_class")
  CustomShogiPlayer.is_mobile_vertical_good_style(
    v-bind="sp_bind"
    v-on="sp_hook"
    :sp_viewpoint.sync="base.sp_viewpoint"
  )

  .footer_buttons(v-if="base.edit_mode_p")

    .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
      b-button(@click="base.king_formation_auto_set(true)") 詰将棋検討用玉配置
      b-button(@click="base.king_formation_auto_set(false)") 玉回収

    .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
      PiyoShogiButton(:href="base.piyo_shogi_app_with_params_url")
      KentoButton(tag="a" :href="base.kento_app_with_params_url" target="_blank")
      KifCopyButton(@click="base.kifu_copy_handle(base.FormatTypeInfo.fetch('kif_utf8'))") コピー

    .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
      b-button(@click="base.any_source_read_handle") 棋譜の読み込み

  .buttons.is-centered.mt-4
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
  name: "ShareBoardSp",
  mixins: [support_child],
  computed: {
    // .column に指定するクラス
    main_column_class() {
      const av = []
      av.push(`is_sb_${this.base.sp_run_mode}`) // is_sb_play_mode, is_sb_edit_mode
      return av
    },

    // CustomShogiPlayer に全部渡す
    sp_bind() {
      const hv = {}
      hv.ref                                         = "main_sp"
      hv["class"]                                    = this.base.sp_class
      hv.sp_run_mode                                 = this.base.sp_run_mode
      hv.sp_turn                                     = this.base.current_turn
      hv.sp_body                                     = this.base.current_sfen
      hv.sp_sound_enabled                            = true
      hv.sp_player_info                              = this.base.sp_player_info
      hv.sp_human_side                               = this.base.sp_human_side
      hv.sp_debug_mode                               = "is_debug_mode_off"
      hv.sp_summary                                  = "is_summary_off"
      hv.sp_play_mode_legal_move_only                = this.base.sp_internal_rule_strict_p
      hv.sp_play_mode_legal_jump_only                = this.base.two_pawn_mode_disallow // 角ワープ true:できない false:できる
      hv.sp_play_mode_legal_pawn_drop                = this.base.two_pawn_mode_disallow // 二歩     true:できない false:できる
      hv.sp_play_mode_only_own_piece_to_move         = this.base.sp_internal_rule_strict_p
      hv.sp_play_mode_can_not_kill_same_team_soldier = this.base.sp_internal_rule_strict_p
      hv.sp_move_cancel                              = this.base.sp_move_cancel_info.key
      hv.sp_layer                                    = this.sp_layer
      hv.sp_controller                               = this.sp_controller
      hv.sp_slider                                   = this.sp_slider

      if (false) {
        hv.sp_bg_variant                             = "is_bg_variant_a"
      }

      return hv
    },

    // 開発時だけレイヤーON
    sp_layer() {
      if (this.development_p) {
        return "is_layer_on"
      } else {
        return "is_layer_off"
      }
    },

    // 対局中にコントローラーは隠す
    sp_controller() {
      if (this.base.controller_disabled_p) {
        return "is_controller_off"
      } else {
        return "is_controller_on"
      }
    },

    // 対局中はスライダーも隠す
    sp_slider() {
      if (this.base.controller_disabled_p) {
        return "is_slider_off"
      } else {
        return "is_slider_on"
      }
    },

    // 動作を受け取るやつら
    sp_hook() {
      const hv = {}
      hv["update:play_mode_advanced_full_moves_sfen"] = this.base.play_mode_advanced_full_moves_sfen_set
      hv["update:edit_mode_snapshot_sfen"]            = this.base.edit_mode_snapshot_sfen_set
      hv["update:mediator_snapshot_sfen"]             = this.base.mediator_snapshot_sfen_set
      hv["update:turn_offset"]                        = v => this.base.current_turn = v
      hv["update:turn_offset_max"]                    = v => this.base.turn_offset_max = v
      hv["operation_invalid1"]                        = this.base.operation_invalid1_handle
      hv["operation_invalid2"]                        = this.base.operation_invalid2_handle
      hv["operation_double_pawn"]                     = this.base.operation_double_pawn_handle
      hv["one_way:sp_turn_user_changed"]              = this.base.sp_turn_user_changed
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

.ShareBoardSp
  .footer_buttons
    .button
      margin-bottom: 0

  ////////////////////////////////////////////////////////////////////////////////
  +tablet
    padding-top: unset
    padding-bottom: unset
    &.is_sb_play_mode
      max-width: calc(var(--board_width) * 1.0vmin)
    &.is_sb_edit_mode
      max-width: calc(var(--board_width) * 1.0vmin * 0.75)

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

  //////////////////////////////////////////////////////////////////////////////// 配色

.ShareBoardApp
  .ShareBoardSp
    // 基本
    --sp_board_color: var(--sb_board_normal_color)

  // 手番
  &.current_turn_self_p
    .ShareBoardSp
      --sp_board_color: var(--sb_board_active_color)
</style>
