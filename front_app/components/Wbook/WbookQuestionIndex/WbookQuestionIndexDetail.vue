<template lang="pug">
.WbookQuestionIndexDetail
  .CustomShogiPlayerWrap
    p(v-if="question.direction_message")
      | {{question.direction_message}}
    CustomShogiPlayer(
      sp_mobile_vertical="is_mobile_vertical_off"
      sp_run_mode="view_mode"
      :sp_body="question.init_sfen"
      :sp_flip_if_white="true"
      :sp_turn="0"
      sp_summary="is_summary_off"
      :sp_sound_enabled="false"
      :sp_op_disabled="true"
      )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WbookQuestionIndexDetail",
  mixins: [support_child],
  props: {
    question: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WbookQuestionIndexDetail
  width: 100%

  display: flex
  justify-content: center
  align-items: center
  flex-direction: column

  .CustomShogiPlayerWrap
    width: 100%
    +tablet
      padding-top: unset
      padding-bottom: unset
      max-width: 60vmin
</style>
