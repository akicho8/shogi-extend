<template lang="pug">
.WkbkBookShowAnswer.columns.is-gapless.is-centered
  .column
    b-tabs(v-model="answer_tab_index" position="is-centered" :vertical="false" :expanded="true" :animated="false" v-if="base.current_article.moves_answers.length >= 1" @input="sound_play('click')")
      template(v-for="(e, i) in base.current_article.moves_answers")
        b-tab-item(:label="`${i + 1}`")
          .CustomShogiPlayerWrap
            CustomShogiPlayer(
              sp_mobile_vertical="is_mobile_vertical_off"
              sp_run_mode="view_mode"
              :sp_body="base.current_article.init_sfen_with(e)"
              :sp_flip_if_white="true"
              :sp_turn="0"
              :sp_sound_body_changed="false"
              sp_summary="is_summary_off"
              sp_slider="is_slider_on"
              sp_controller="is_controller_on"
              )
    .box.is-shadowless.has-background-white-ter(v-if="base.current_article.description" v-html="simple_format(auto_link(base.current_article.description))")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowAnswer",
  mixins: [support_child],
  data() {
    return {
      answer_tab_index: 0,
    }
  },
}
</script>

<style lang="sass">
@import "../support.sass"

$wkbk_book_show_answer_width: 66vmin

.STAGE-development
  .CustomShogiPlayerWrap
    border: 1px dashed change_color($primary, $alpha: 0.5)

.WkbkBookShowAnswer
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
          margin-top: $wkbk_share_gap
          margin-bottom: $wkbk_share_gap // 下を開けないとスライダーのボタンの大きさで縦サイズが変化してしまう
          width: 100%
          +tablet
            padding-top: unset
            padding-bottom: unset
            max-width: $wkbk_book_show_answer_width
  .box
    width: 100%
    +tablet
      max-width: $wkbk_book_show_answer_width
</style>
