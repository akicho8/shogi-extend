<template lang="pug">
// keyを指定すると2回目の描画のときに b-tab-item の部分が正しく更新される
.WkbkBookShowAnswer.columns.is-gapless.is-centered
  .column
    .box

    //- b-tabs(v-model="base.answer_tab_index" position="is-centered" :vertical="false" :expanded="true" :animated="false" v-if="base.current_article.moves_answers.length >= 1" @input="sound_play('click')")
    //-   template(v-for="(e, i) in base.current_article.moves_answers")
    //-     b-tab-item(:label="`${i + 1}`")
    //-       .CustomShogiPlayerWrap
    //-         CustomShogiPlayer(
    //-           sp_mobile_vertical="is_mobile_vertical_off"
    //-           sp_run_mode="view_mode"
    //-           :sp_body="base.current_article.init_sfen_with(e)"
    //-           :sp_flip_if_white="true"
    //-           :sp_turn="0"
    //-           :sp_sound_body_changed="false"
    //-           sp_summary="is_summary_off"
    //-           sp_slider="is_slider_on"
    //-           sp_controller="is_controller_on"
    //-           )
    .box.is-shadowless.has-background-white-ter(
      v-if="base.current_article.description"
      v-html="simple_format(auto_link(base.current_article.description))"
      )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowAnswer",
  mixins: [support_child],
  data() {
    return {
    }
  },
}
</script>

<style lang="sass">
@import "../support.sass"

.WkbkBookShowAnswer
  .column
    display: flex
    align-items: center
    flex-direction: column
  .box
    width: 100%
    +tablet
      max-width: 66vmin
</style>
