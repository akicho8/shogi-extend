<template lang="pug">
.WkbkArticleEditValidation.columns.is-gapless.is-centered
  .column
    .CustomShogiPlayerWrap
      .has-text-centered(v-if="base.article.direction_message")
        | {{base.article.direction_message}}
      CustomShogiPlayer(
        sp_mobile_vertical="is_mobile_vertical_off"
        sp_run_mode="play_mode"
        :sp_body="base.article.init_sfen"
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
  name: "WkbkArticleEditValidation",
  mixins: [
    support_child,
  ],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleEditValidation
  .column
    display: flex
    align-items: center
    justify-content: center
    flex-direction: column
  .CustomShogiPlayerWrap
    width: 100%
    margin: $wkbk_share_gap 0
    +tablet
      padding-top: unset
      padding-bottom: unset
      max-width: 66vmin
</style>
