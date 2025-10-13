<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 手合割
    div
      span.mx-1 評価値
      span(v-if="SB.board_preset_info.handicap_level >= 1") +
      | {{SB.board_preset_info.handicap_level}}
  .modal-card-body
    .select_container
      b-select.board_preset_key(v-model="SB.board_preset_key" @input="sfx_click()")
        option(v-for="e in SB.BoardPresetInfo.values" :value="e.key" v-text="e.name")
    .sp_container.mt-4
      CustomShogiPlayer(
        sp_mode="view"
        :sp_mobile_vertical="false"
        sp_layout="horizontal"
        sp_piece_variant="paper"
        :sp_piece_stand_blank_then_hidden="false"
        sp_operation_disabled
        :sp_turn="0"
        :sp_body="SB.board_preset_info.sfen"
      )
    .description_container.mt-4
      .description
        | {{SB.board_preset_info.description}}
    .buttons_container.buttons.has-addons.is-centered.mb-0.mt-4
      b-button.mb-0(@click="next_handle(-1)" icon-left="chevron-left")
      b-button.mb-0(@click="next_handle(1)" icon-left="chevron-right")
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.apply_button(@click="apply_handle" type="is-primary") 適用
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "PresetSelectModal",
  mixins: [support_child],
  methods: {
    next_handle(v) {
      this.sfx_click()
      const i = this.SB.board_preset_info.code + v
      const new_index = this.$GX.imodulo(i, this.SB.BoardPresetInfo.values.length)
      const next = this.SB.BoardPresetInfo.fetch(new_index)
      this.SB.board_preset_key = next.key
    },
    close_handle() {
      this.sfx_click()
      this.SB.preset_select_modal_close()
    },
    apply_handle() {
      this.sfx_click()
      this.SB.force_sync_preset()
      this.SB.preset_select_modal_close()
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.PresetSelectModal
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
    +setvar(sp_board_padding, 0)
    +setvar(sp_board_color, transparent)
    +setvar(sp_grid_outer_stroke, 0)
    +setvar(sp_grid_outer_color, hsl(0, 0%, 80%))
    +setvar(sp_grid_inner_color, hsl(0, 0%, 80%))

.STAGE-development
  .PresetSelectModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
