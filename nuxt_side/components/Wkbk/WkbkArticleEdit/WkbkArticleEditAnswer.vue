<template lang="pug">
MainSection.WkbkArticleEditAnswer
  .container
    .columns.is-centered
      .column.LeftColumn
        .CustomShogiPlayerWrap
          CustomShogiPlayer(
            :sp_body="base.article.init_sfen"
            :sp_viewpoint="base.article.viewpoint"
            :sp_turn="0"
            :sp_mobile_vertical="false"
            sp_mode="play"
            sp_slider
            sp_controller
            @ev_turn_offset_change="base.ev_turn_offset_change"
            @ev_play_mode_move="base.ev_play_mode_move"
            ref="main_sp"
            )

          .buttons.mb-0.is-centered.are-small.is-marginless.mt-4
            PiyoShogiButton.mb-0(:href="base.answer_base_piyo_shogi_app_with_params_url")
            KentoButton.mb-0(tag="a" :href="base.answer_base_kento_app_with_params_url" target="_blank")
            KifCopyButton.mb-0(@click="base.answer_base_kifu_copy_handle") コピー

          .buttons.is-centered.mt-4.mb-0
            b-button.mb-0(@click="base.answer_create_handle" :type="{'is-primary': base.answer_base_turn_offset >= 1}")
              | {{base.answer_base_turn_offset}}手目までの手順を正解とする

      .column.RightColumn
        b-tabs(v-model="base.answer_tab_index" position="is-centered" :vertical="false" :expanded="true" :animated="false" v-if="base.article.moves_answers.length >= 1" @input="sfx_click()")
          template(v-for="(e, i) in base.article.moves_answers")
            b-tab-item(:label="`${i + 1}`" :key="e.moves.join(' ')")
              .CustomShogiPlayerWrap
                CustomShogiPlayer(
                  :sp_mobile_vertical="false"
                  sp_mode="view"
                  :sp_body="base.article.init_sfen_with(e)"
                  :sp_viewpoint="base.article.viewpoint"
                  :sp_turn="-1"
                  sp_slider
                  sp_controller
                  )
                .buttons.mb-0.is-centered.are-small.is-marginless.mt-4
                  PiyoShogiButton.mb-0(:href="base.answers_piyo_shogi_app_with_params_url(e)")
                  KentoButton.mb-0(tag="a" :href="base.answers_kento_app_with_params_url(e)" target="_blank")
                  KifCopyButton.mb-0(@click="base.answers_kifu_copy_handle(e)") コピー

                .is-flex.is-justify-content-center.mt-4
                  b-button.delete_button.has-text-danger(@click="base.answer_delete_at(i)" icon-left="trash-can-outline" type="is-text")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleEditAnswer",
  mixins: [support_child],
  methods: {
  },
}
</script>

<style lang="sass">
@import "../support.sass"

.STAGE-development
  .delete_button
    border: 1px dashed change_color($primary, $alpha: 0.5)

.MainSection.section.WkbkArticleEditAnswer
  padding: 0

  .LeftColumn.column
    display: flex
    align-items: center
    flex-direction: column
    .CustomShogiPlayerWrap
      +mobile
        margin-top: 0.5rem
      +tablet
        margin-top: 4rem

  .RightColumn.column
    +mobile
      margin-top: 1rem

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
      max-width: 60dvmin
      padding-top: unset
      padding-bottom: unset
</style>
