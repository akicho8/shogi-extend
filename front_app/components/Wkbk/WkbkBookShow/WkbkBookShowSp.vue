<template lang="pug">
.WkbkBookShowSp.columns.is-gapless.is-centered
  .column
    .CustomShogiPlayerWrap
      .has-text-centered(v-if="base.current_article.direction_message")
        | {{base.current_article.direction_message}}
      CustomShogiPlayer(
        :sp_body="base.current_sp_body"
        :sp_viewpoint="base.current_sp_viewpoint"
        :sp_turn="0"
        :sp_sound_body_changed="false"
        sp_run_mode="play_mode"
        sp_summary="is_summary_off"
        sp_slider="is_slider_on"
        sp_controller="is_controller_on"
        @update:play_mode_advanced_moves="base.play_mode_advanced_moves_set"
        )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowSp",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowSp
  .column
    display: flex
    align-items: center
    justify-content: center
    flex-direction: column
  .CustomShogiPlayerWrap
    width: 100%
    +mobile
      margin-top: 0.5rem
    +tablet
      margin-top: $wkbk_share_gap
      padding-top: unset
      padding-bottom: unset
      max-width: 66vmin
</style>
