<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title 手合割
    .evaluation_value 評価値 {{SB.board_preset_info.handicap_desc}}
  .modal-card-body
    b-select.board_preset_key(v-model="SB.board_preset_key" @input="sfx_click()")
      option(v-for="e in SB.BoardPresetInfo.values" :value="e.key" v-text="e.name")
    CustomShogiPlayer.CustomShogiPlayerInsideModal(
      sp_mode="view"
      :sp_body="SB.board_preset_info.sfen"
      :sp_mobile_vertical="false"
      sp_layout="horizontal"
      sp_operation_disabled
    )
    .description(v-html="SB.board_preset_info.description")
    .buttons.has-addons.is-centered.mb-0
      b-button.mb-0.board_preset_step_handle.previous(@click="SB.board_preset_step_handle(-1)" icon-left="chevron-left")
      b-button.mb-0.board_preset_step_handle.next(@click="SB.board_preset_step_handle(1)" icon-left="chevron-right")
  .modal-card-foot
    b-button.board_preset_modal_close_handle.has-text-weight-normal(@click="SB.board_preset_modal_close_handle" icon-left="chevron-left")
    b-button.board_preset_apply_handle(@click="SB.board_preset_apply_handle" type="is-primary" :disabled="!SB.board_preset_info.can_apply") 適用
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "BoardPresetModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.BoardPresetModal
  .modal-card-body
    padding: 1.25rem
    gap: 1.0rem

    display: flex
    align-items: center
    justify-content: center
    flex-direction: column

    .button
      min-width: 8rem

.STAGE-development
  .BoardPresetModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
