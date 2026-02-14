<template lang="pug">
MainSection.WkbkArticleEditValidation
  .container
    .columns
      .column
        .CustomShogiPlayerWrap
          .has-text-centered(v-if="base.article.direction_message")
            | {{base.article.direction_message}}
          CustomShogiPlayer(
            :sp_mobile_vertical="false"
            sp_mode="play"
            :sp_body="base.article.init_sfen"
            :sp_viewpoint="base.article.viewpoint"
            :sp_turn="0"
            sp_slider
            sp_controller
            @ev_play_mode_next_moves="base.ev_play_mode_next_moves"
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
.MainSection.section.WkbkArticleEditValidation
  padding: 0
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
      max-width: 66dvmin
</style>
