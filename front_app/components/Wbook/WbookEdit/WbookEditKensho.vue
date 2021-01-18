<template lang="pug">
.WbookEditKensho
  .has-text-centered(v-if="base.question.direction_message")
    | {{base.question.direction_message}}

  CustomShogiPlayer(
    sp_mobile_vertical="is_mobile_vertical_off"
    sp_run_mode="play_mode"
    :sp_body="base.question.init_sfen"
    :sp_flip_if_white="true"
    :sp_turn="0"
    sp_slider="is_slider_on"
    sp_controller="is_controller_on"
    @update:play_mode_advanced_moves="base.play_mode_advanced_moves_set"
    )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WbookEditKensho",
  mixins: [
    support_child,
  ],
  created() {
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.WbookEditKensho
  margin-top: 1.5rem
</style>
