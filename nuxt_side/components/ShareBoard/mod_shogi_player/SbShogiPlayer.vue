<template lang="pug">
.SbShogiPlayer.ToastMainBoard.MainColumn.column(:class="main_column_class")
  CustomShogiPlayer(
    v-bind="sp_component_attributes"
    v-on="sp_component_events"
    :sp_viewpoint.sync="SB.viewpoint"
  )
  SbEditModeToolBelt
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbShogiPlayer",
  mixins: [support_child],
  computed: {
    // .column に指定するクラス
    main_column_class() {
      const av = []
      av.push(`is_sb_mode_${this.SB.sp_mode}`) // is_sb_mode_play, is_sb_mode_edit
      return av
    },

    // CustomShogiPlayer に全部渡す
    sp_component_attributes() {
      const hv = {}
      hv.ref                         = "main_sp"
      hv["class"]                    = this.SB.sp_component_class

      // ここ以降 hv.sp_* = でないとおかしいので注意
      hv.sp_mode                    = this.SB.sp_mode
      hv.sp_turn                    = this.SB.current_turn
      hv.sp_body                    = this.SB.current_sfen
      hv.sp_player_info             = this.SB.sp_player_info
      hv.sp_human_side              = this.SB.sp_human_side
      hv.sp_think_mark_collection   = this.SB.sp_think_mark_collection
      hv.sp_origin_mark_collection  = this.SB.sp_origin_mark_collection
      hv.sp_legal_move_only         = this.SB.legal_strict_p
      hv.sp_my_piece_only_move      = this.SB.legal_strict_p
      hv.sp_my_piece_kill_disabled  = this.SB.legal_strict_p
      hv.sp_lift_cancel_action      = this.SB.lift_cancel_action_info.key
      hv.sp_mobile_vertical         = this.SB.mobile_layout_info.sp_mobile_vertical
      hv.sp_layout                  = this.SB.desktop_layout_info.sp_layout
      hv.sp_layer                   = this.development_p
      hv.sp_controller              = this.SB.controller_show_p
      hv.sp_slider                  = this.SB.controller_show_p
      hv.sp_mounted_focus_to_slider = true // マウントしたらスライダーにフォーカスする

      hv.sp_request_checkmate_stat = true // 詰み判定する
      hv.sp_request_position_hash  = true // 操作モードで千日手判定用に現局面のSFENをイベントに含める
      hv.sp_request_op_king_check  = true // 操作モードで王手しているかどうかの結果をイベントに含める

      // スマホでのUI確認用
      if (false) {
        hv.sp_device = "touch"
      }

      hv.sp_piece_variant          = this.SB.appearance_theme_info.sp_piece_variant
      hv.sp_board_variant          = this.SB.appearance_theme_info.sp_board_variant
      hv.sp_board_variant_to_stand = true

      if (this.SB.order_enable_p || this.SB.cc_play_p) {
        // 反則時の挙動
        hv.sp_illegal_validate = this.SB.foul_mode_info.sp_illegal_validate
        hv.sp_illegal_cancel   = this.SB.foul_mode_info.sp_illegal_cancel
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

    // 動作を受け取るやつら
    sp_component_events() {
      const hv = {}

      hv["ev_play_mode_move"]              = this.SB.ev_play_mode_move
      hv["ev_edit_mode_short_sfen_change"] = this.SB.ev_edit_mode_short_sfen_change
      hv["ev_short_sfen_change"]           = this.SB.ev_short_sfen_change
      hv["ev_turn_offset_change"]          = v => this.SB.current_turn = v
      hv["ev_turn_offset_max_change"]      = v => this.SB.turn_offset_max = v

      hv["ev_action_viewpoint_flip"]       = this.SB.ev_action_viewpoint_flip       // 意図して☗☖をタップして反転させたとき
      hv["ev_action_turn_change"]          = this.SB.ev_action_turn_change          // スライダーを動かしたとき
      hv["ev_action_piece_lift"]           = this.SB.ev_action_piece_lift           // 意図して持ち上げた
      hv["ev_action_piece_cancel"]         = this.SB.ev_action_piece_cancel         // 意図してキャンセルした
      hv["ev_action_promote_select_open"]  = this.SB.ev_action_promote_select_open  // 成 or 不成 選択モードに入る
      hv["ev_action_promote_select_close"] = this.SB.ev_action_promote_select_close // 成 or 不成 選択モードから出る

      // 手番 or 先後違い系
      hv["ev_illegal_click_but_self_is_not_turn"] = this.SB.ev_illegal_click_but_self_is_not_turn // 手番が違うのに操作しようとした
      hv["ev_illegal_my_turn_but_oside_click"]    = this.SB.ev_illegal_my_turn_but_oside_click    // 自分が手番だが相手の駒を動かそうとした

      // 反則系
      hv["ev_illegal_illegal_accident"] = this.SB.ev_illegal_illegal_accident

      // マークできる箇所をタップした
      hv["ev_think_mark_click"] = this.SB.ev_think_mark_click

      // 移動元印
      hv["ev_action_origin_mark_jump_invoke"] = this.SB.ev_action_origin_mark_jump_invoke
      hv["ev_action_origin_mark_jump_cancel"] = this.SB.ev_action_origin_mark_jump_cancel

      return hv
    },
  },
}
</script>

<style lang="sass">
@import "../stylesheets/support"
@import "shogi-player/components/support"

.SbShogiPlayer
  +setvar(sp_grid_inner_stroke, var(--sb_grid_stroke))  // グリッドの太さ
  +setvar(sp_location_mark_inactive_size, 1.0)          // 手番でない方の☗の大きさ

  +setvar(sp_board_horizontal_gap, 0.075)      // 盤の左右の隙間(全体横レイアウト時)
  +setvar(sp_board_vertical_gap, 0.075)        // 盤の上下の隙間(全体縦レイアウト時)
  +setvar(sp_membership_vertical_gap, 0.075)   // 盤の左右の隙間(全体横レイアウト時)
  +setvar(sp_membership_horizontal_gap, 0.075) // 盤の上下の隙間(全体縦レイアウト時)

  padding-inline: unset

  // デスクトップ以上では大きさは動的に変更できる
  +desktop
    padding-block: unset
    &.is_sb_mode_play
      max-width: calc(var(--sb_board_width) * 1.0dvmin)
    &.is_sb_mode_edit
      max-width: calc(var(--sb_board_width) * 1.0dvmin * 0.75)

  //////////////////////////////////////////////////////////////////////////////// 残り時間の少なさを背景色で伝える
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

.SbApp.debug_mode_p
  .CustomShogiPlayer
    .MembershipLocationPlayerInfoName
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .MembershipLocationPlayerInfoTime
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .MembershipLocationMarkTexture
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
