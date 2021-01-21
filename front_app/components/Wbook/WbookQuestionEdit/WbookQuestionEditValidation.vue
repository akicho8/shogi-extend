<template lang="pug">
.WbookQuestionEditValidation.columns.is-gapless.is-centered
  .column
    .CustomShogiPlayerWrap
      .has-text-centered(v-if="base.question.direction_message")
        | {{base.question.direction_message}}
      CustomShogiPlayer(
        sp_mobile_vertical="is_mobile_vertical_off"
        sp_run_mode="play_mode"
        :sp_body="base.question.init_sfen"
        :sp_flip_if_white="true"
        :sp_turn="0"
        sp_summary="is_summary_off"
        sp_slider="is_slider_on"
        sp_controller="is_controller_on"
        @update:play_mode_advanced_moves="base.play_mode_advanced_moves_set"
        )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WbookQuestionEditValidation",
  mixins: [
    support_child,
  ],
  created() {
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WbookQuestionEditValidation
  .column
    display: flex
    align-items: center
    justify-content: center
    flex-direction: column
  .CustomShogiPlayerWrap
    width: 100%
    margin-top: $wbook_share_gap
    +tablet
      padding-top: unset
      padding-bottom: unset
      max-width: 66vmin
</style>
