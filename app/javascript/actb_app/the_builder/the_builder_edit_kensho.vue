<template lang="pug">
.the_builder_edit_kensho
  .has-text-centered(v-if="$parent.question.direction_message")
    | {{$parent.question.direction_message}}

  shogi_player(
    :run_mode="'play_mode'"
    :kifu_body="$parent.question.init_sfen"
    :flip_if_white="true"
    :start_turn="0"
    :slider_show="true"
    :controller_show="true"
    :setting_button_show="false"
    :theme="app.config.sp_theme"
    :size="app.config.sp_size"
    :sound_effect="true"
    :volume="0.5"
    @update:play_mode_advanced_moves="$parent.play_mode_advanced_moves_set"
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
