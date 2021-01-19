<template lang="pug">
.WbookEditSeikai.columns.is-gapless.is-centered
  .column.LeftColumn
    .CustomShogiPlayerWrap
      CustomShogiPlayer(
        sp_mobile_vertical="is_mobile_vertical_off"
        sp_run_mode="play_mode"
        :sp_body="base.question.init_sfen"
        :sp_flip_if_white="true"
        :sp_turn="0"
        sp_slider="is_slider_on"
        sp_controller="is_controller_on"
        sp_summary="is_summary_off"
        @update:turn_offset="base.turn_offset_set"
        @update:mediator_snapshot_sfen="base.mediator_snapshot_sfen_set"
        ref="main_sp"
        )
      .buttons.is-centered.edit_stock_handle
        b-button(@click="base.edit_stock_handle" :type="{'is-primary': base.answer_turn_offset >= 1}" size="is-small")
          | {{base.answer_turn_offset}}手目までの手順を正解とする

  .column.RightColumn
    b-tabs(v-model="base.answer_tab_index" position="is-centered" expanded :animated="false" v-if="base.question.moves_answers.length >= 1" @input="sound_play('click')")
      template(v-for="(e, i) in base.question.moves_answers")
        b-tab-item(:label="`${i + 1}`" :key="`tab_${i}_${e.moves_str}`")
          .CustomShogiPlayerWrap
            CustomShogiPlayer(
              sp_mobile_vertical="is_mobile_vertical_off"
              sp_run_mode="view_mode"
              :sp_body="base.full_sfen_build(e)"
              :sp_flip_if_white="true"
              :sp_turn="-1"
              sp_summary="is_summary_off"
              sp_slider="is_slider_on"
              sp_controller="is_controller_on"
              )
            .is-flex.is-justify-content-flex-end
              b-button.delete_button.has-text-danger(@click="base.moves_answer_delete_handle(i)" icon-left="trash-can-outline" type="is-text")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WbookEditSeikai",
  mixins: [support_child],
  created() {
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.STAGE-development
  .delete_button
    border: 1px dashed change_color($primary, $alpha: 0.5)

.WbookEditSeikai
  .LeftColumn
    display: flex
    justify-content: center
    align-items: center
    flex-direction: column
    .CustomShogiPlayerWrap
      width: 100%
      +tablet
        padding-top: unset
        padding-bottom: unset
        max-width: 64vmin
      .edit_stock_handle
        margin-top: 1rem
  .RightColumn
    display: flex
    justify-content: center
    align-items: center
    flex-direction: column
    .tab-content
      // position: relative
      // .delete_button
      //   margin-top: 0.5rem
      //   margin-left: 0.5rem
      .tab-item
        display: flex
        justify-content: center
        align-items: center
        flex-direction: column
        .CustomShogiPlayerWrap
          width: 100%
          +tablet
            padding-top: unset
            padding-bottom: unset
            max-width: 65vmin
</style>
