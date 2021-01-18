<template lang="pug">
.WbookBuilderEditKensho
  .has-text-centered(v-if="bapp.question.direction_message")
    | {{bapp.question.direction_message}}

  CustomShogiPlayer(
    sp_mobile_vertical="is_mobile_vertical_off"
    sp_run_mode="play_mode"
    :sp_body="bapp.question.init_sfen"
    :sp_flip_if_white="true"
    :sp_turn="0"
    sp_slider="is_slider_on"
    sp_controller="is_controller_on"
    @update:play_mode_advanced_moves="bapp.play_mode_advanced_moves_set"
    )
</template>

<script>
import { builder_support } from "./builder_support.js"

export default {
  name: "WbookBuilderEditKensho",
  mixins: [
    builder_support,
  ],
  created() {
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WbookBuilderEditKensho
  margin-top: 1.5rem
</style>
