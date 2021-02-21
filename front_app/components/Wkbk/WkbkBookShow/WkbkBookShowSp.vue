<template lang="pug">
MainSection.WkbkBookShowSp
  .container.is-fluid
    .columns
      .column.LeftColumn
        .CustomShogiPlayerWrap
          .has-text-centered.is_truncate1
            span.has-text-weight-bold(v-if="base.current_article.title")
              | {{base.current_article.title}}
            span.ml-1(v-if="base.current_article.direction_message")
              | {{base.current_article.direction_message}}
          CustomShogiPlayer(
            sp_mobile_vertical="is_mobile_vertical_off"
            :sp_body="base.current_article.init_sfen"
            :sp_viewpoint="base.current_article.viewpoint"
            :sp_turn="0"
            :sp_sound_body_changed="false"
            sp_run_mode="play_mode"
            sp_summary="is_summary_off"
            sp_slider="is_slider_off"
            sp_controller="is_controller_on"
            @update:play_mode_advanced_moves="base.play_mode_advanced_moves_set"
            )
          //- .buttons.is-centered.answer_create_handle
          //-   b-button(@click="base.answer_create_handle" :type="{'is-primary': base.answer_turn_offset >= 1}" size="is-small")
          //-     | {{base.answer_turn_offset}}手目までの手順を正解とする

          //- .ox_buttons.is-flex.is-justify-content-center.my-4.has-addons
          //-   template(v-for="e in base.AnswerKindInfo.values")
          //-     b-button.is-outlined(:icon-left="e.icon" @click="base.next_handle(e)")

          WkbkBookShowOxButtons.mt-4(:base="base")

      .column.RightColumn(:key="base.current_article.key" v-if="base.current_article.moves_answers.length >= 1")
        b-tabs.mb-0(
          v-model="base.answer_tab_index"
          position="is-centered"
          :vertical="false"
          :expanded="true"
          :animated="false"
          @input="sound_play('click')"
          )
          template(v-for="(e, i) in base.current_article.moves_answers")
            b-tab-item(:label="`${i + 1}`")
              .CustomShogiPlayerWrap
                CustomShogiPlayer(
                  sp_mobile_vertical="is_mobile_vertical_off"
                  sp_run_mode="view_mode"
                  :sp_body="base.current_article.init_sfen_with(e)"
                  :sp_turn="0"
                  :sp_viewpoint="base.current_article.viewpoint"
                  :sp_sound_body_changed="false"
                  sp_summary="is_summary_off"
                  sp_slider="is_slider_off"
                  sp_controller="is_controller_on"
                  )

        template(v-if="base.current_article.description")
          .is-flex.is-justify-content-center.my-4(v-if="!base.description_open_p")
            b-button(@click="base.description_open_handle") 解説
          .box(v-if="base.description_open_p" v-html="simple_format(auto_link(base.current_article.description))")
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
.MainSection.section.WkbkBookShowSp
  padding: 0 0 3rem // 押しやすくするため下を開ける

  .column.LeftColumn
    display: flex
    align-items: center
    flex-direction: column
    // .CustomShogiPlayerWrap
    //   .answer_create_handle
    //     margin-top: $wkbk_share_gap
    .CustomShogiPlayerWrap
      +mobile
        margin-top: 0.5rem
      +tablet
        margin-top: 2.5rem

  .column.RightColumn
    +mobile
      margin-top: 0.5rem
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
      +mobile
        margin-top: 0.5rem
      +tablet
        margin-top: 1.5rem

  // 共通
  .CustomShogiPlayerWrap
    width: 100%
    +tablet
      max-width: 68vmin
      padding-top: unset
      padding-bottom: unset

  .box
    margin: 1rem
</style>
