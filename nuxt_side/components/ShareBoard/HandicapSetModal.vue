<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 手合割
    div
      span.mx-1 評価値
      span(v-if="base.handicap_preset_info.handicap_level >= 1") +
      | {{base.handicap_preset_info.handicap_level}}
  .modal-card-body
    .select_container
      b-select.handicap_preset_key(v-model="base.handicap_preset_key" @input="sound_play_click()")
        option(v-for="e in base.HandicapPresetInfo.values" :value="e.key" v-text="e.name")
    .sp_container.mt-4
      CustomShogiPlayer(
        sp_summary="is_summary_off"
        sp_run_mode="view_mode"
        sp_mobile_vertical="is_mobile_vertical_off"
        sp_layout="is_horizontal"
        sp_pi_variant="is_pi_variant_b"
        :sp_hidden_if_piece_stand_blank="false"
        :sp_op_disabled="true"
        :sp_sound_enabled="false"
        :sp_turn="0"
        :sp_body="base.handicap_preset_info.sfen"
      )
    .description_container.mt-4
      .description
        | {{base.handicap_preset_info.description}}
    .buttons_container.buttons.has-addons.is-centered.mb-0.mt-4
      b-button.mb-0(@click="next_handle(-1)" icon-left="chevron-left")
      b-button.mb-0(@click="next_handle(1)" icon-left="chevron-right")
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.apply_button(@click="apply_handle" type="is-primary") 適用
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "HandicapSetModal",
  mixins: [support_child],
  methods: {
    next_handle(v) {
      this.sound_play_click()
      const i = this.base.handicap_preset_info.code + v
      const new_index = this.ruby_like_modulo(i, this.base.HandicapPresetInfo.values.length)
      const next = this.base.HandicapPresetInfo.fetch(new_index)
      this.base.handicap_preset_key = next.key
    },
    close_handle() {
      this.sound_play_click()
      this.$emit("close")
    },
    apply_handle() {
      this.sound_play_click()
      this.base.force_sync_handicap()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.HandicapSetModal
  +modal_width(32rem)
  .modal-card-body
    padding: 1.25rem
    .select_container
      display: flex
      justify-content: center
    .sp_container
      display: flex
      justify-content: center
    .description_container
      display: flex
      justify-content: center
    .buttons_container
      .button
        min-width: 8rem

  .CustomShogiPlayer
    width: 16rem
    --sp_board_padding: 0
    --sp_board_color: transparent
    --sp_shadow_offset: 0
    --sp_shadow_blur: 0
    --sp_grid_outer_stroke: 0
    --sp_grid_outer_color: hsl(0, 0%, 80%)
    --sp_grid_color:       hsl(0, 0%, 80%)
    --sp_stand_piece_w: 22px
    --sp_stand_piece_h: 22px

.STAGE-development
  .HandicapSetModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
