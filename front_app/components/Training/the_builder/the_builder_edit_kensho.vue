<template lang="pug">
.the_builder_edit_kensho
  .has-text-centered(v-if="bapp.question.direction_message")
    | {{bapp.question.direction_message}}

  MyShogiPlayer(
    :run_mode="'play_mode'"
    :kifu_body="bapp.question.init_sfen"
    :flip_if_white="true"
    :start_turn="0"
    :slider_show="true"
    :controller_show="true"
    :setting_button_show="false"
    :theme="app.config.sp_theme"
    :size="app.config.sp_size"
    :sound_effect="true"
    :volume="0.5"
    @update:play_mode_advanced_moves="bapp.play_mode_advanced_moves_set"
    )
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_builder_edit_kensho",
  mixins: [
    support,
  ],
  created() {
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_builder_edit_kensho
  margin-top: 1.5rem
</style>
