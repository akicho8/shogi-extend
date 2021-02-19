<template lang="pug">
MainSection.WkbkArticleShowAnswer
  .container
    .columns.is-centered
      .column
        b-tabs(v-model="base.answer_tab_index" position="is-centered" :vertical="false" :expanded="true" :animated="false" v-if="base.article.moves_answers.length >= 1" @input="sound_play('click')")
          template(v-for="(e, i) in base.article.moves_answers")
            b-tab-item(:label="`${i + 1}`" :key="e.id")
              .CustomShogiPlayerWrap
                CustomShogiPlayer(
                  sp_mobile_vertical="is_mobile_vertical_off"
                  sp_run_mode="view_mode"
                  :sp_body="base.article.init_sfen_with(e)"
                  :sp_viewpoint="base.article.viewpoint"
                  :sp_turn="-1"
                  :sp_sound_body_changed="false"
                  sp_summary="is_summary_off"
                  sp_slider="is_slider_on"
                  sp_controller="is_controller_on"
                  )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleShowAnswer",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"

.STAGE-development
  .delete_button
    border: 1px dashed change_color($primary, $alpha: 0.5)

.MainSection.section.WkbkArticleShowAnswer
  padding: 0

  .column
    display: flex
    align-items: center
    flex-direction: column
    .tab-content
      padding: 0
      .tab-item
        display: flex
        justify-content: center
        align-items: center
        flex-direction: column
        .CustomShogiPlayerWrap
          margin: $wkbk_share_gap 0
          width: 100%
          +tablet
            max-width: 66vmin
            padding-top: unset
            padding-bottom: unset
</style>
