<template lang="pug">
.ShareBoardSp.MainColumn.column(:class="base.main_column_class")
  CustomShogiPlayer.is_mobile_vertical_good_style(v-bind="sp_bind" v-on="sp_hook")

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
    b-button.has-text-weight-bold(:type="base.advanced_p ? 'is-twitter' : ''" v-if="base.tweet_button_show_p" icon-left="twitter" @click="base.tweet_modal_handle") ツイート
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardSp",
  mixins: [support_child],
  computed: {
    sp_bind() {
      const hv = {}
      hv.ref                                         = "main_sp"
      hv["class"]                                    = this.base.sp_class
      hv.sp_run_mode                                 = this.base.sp_run_mode
      hv.sp_turn                                     = this.base.current_turn
      hv.sp_body                                     = this.base.current_sfen
      hv.sp_sound_enabled                            = true
      hv["sp_viewpoint.sync"]                        = this.base.sp_viewpoint
      hv.sp_player_info                              = this.base.sp_player_info
      hv.sp_human_side                               = this.base.sp_human_side
      hv.sp_debug_mode                               = "is_debug_mode_off"
      hv.sp_summary                                  = "is_summary_off"
      hv.sp_play_mode_legal_move_only                = this.base.sp_internal_rule_strict_p
      hv.sp_play_mode_legal_jump_only                = false
      hv.sp_play_mode_only_own_piece_to_move         = this.base.sp_internal_rule_strict_p
      hv.sp_play_mode_can_not_kill_same_team_soldier = this.base.sp_internal_rule_strict_p
      hv.sp_move_cancel                              = this.base.sp_move_cancel_info.key
      hv.sp_layer                                    = this.sp_layer
      hv.sp_controller                               = this.sp_controller
      hv.sp_slider                                   = this.sp_slider
      return hv
    },
    sp_layer() {
      if (this.development_p) {
        return "is_layer_on"
      } else {
        return "is_layer_off"
      }
    },
    sp_controller() {
      if (this.base.controller_disabled_p) {
        return "is_controller_off"
      } else {
        return "is_controller_on"
      }
    },
    sp_slider() {
      if (this.base.controller_disabled_p) {
        return "is_slider_off"
      } else {
        return "is_slider_on"
      }
    },
    sp_hook() {
      const hv = {}
      hv["update:play_mode_advanced_full_moves_sfen"] = this.base.play_mode_advanced_full_moves_sfen_set
      hv["update:edit_mode_snapshot_sfen"]            = this.base.edit_mode_snapshot_sfen_set
      hv["update:mediator_snapshot_sfen"]             = this.base.mediator_snapshot_sfen_set
      hv["update:turn_offset"]                        = v => this.base.current_turn = v
      hv["update:turn_offset_max"]                    = v => this.base.turn_offset_max = v
      hv["operation_invalid1"]                        = this.base.operation_invalid1_handle
      hv["operation_invalid2"]                        = this.base.operation_invalid2_handle
      hv["one_way:sp_turn_user_changed"]              = this.base.sp_turn_user_changed
      return hv
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
</style>
