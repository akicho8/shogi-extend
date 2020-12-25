<template lang="pug">
.ActbBuilderEditKensho
  .has-text-centered(v-if="bapp.question.direction_message")
    | {{bapp.question.direction_message}}

  CustomShogiPlayer(
    :sp_mobile_vertical="'is_mobile_vertical_off'"
    :run_mode="'play_mode'"
    :kifu_body="bapp.question.init_sfen"
    :flip_if_white="true"
    :start_turn="0"
    sp_slider="is_slider_on"
    :controller_show="true"
    :setting_button_show="false"
    @update:play_mode_advanced_moves="bapp.play_mode_advanced_moves_set"
    )
</template>

<script>
import { builder_support } from "./builder_support.js"

export default {
  name: "ActbBuilderEditKensho",
  mixins: [
    builder_support,
  ],
  created() {
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbBuilderEditKensho
  margin-top: 1.5rem
</style>
