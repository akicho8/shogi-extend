<template lang="pug">
MainSection.WkbkBookShowSp
  .container.is-fluid
    .columns
      .column.LeftColumn
        .CustomShogiPlayerWrap
          .article_title_block.has-text-centered.is_truncate1(v-if="base.article_title_display_info.key === 'display'")
            span.has-text-weight-bold(v-if="base.current_article.title")
              | {{base.current_article.title || "(no title)"}}
            span.ml-1(v-if="base.current_article.direction_message")
              | {{base.current_article.direction_message}}

          //- p {{base.current_sfen}}
          //- p {{base.current_init_sfen}}
          // sp_device="touch"
          CustomShogiPlayer(
            ref="main_sp"
            v-bind="sp_bind"
            v-on="sp_hook"
            :sp_body="base.current_init_sfen"
            :sp_viewpoint="base.current_viewpoint"
            :sp_turn="-1"
            sp_mode="play"
            sp_controller
            :sp_mobile_vertical="false"
            @ev_play_mode_next_moves="base.ev_play_mode_next_moves"
            )
          //- .buttons.is-centered.answer_create_handle
          //-   b-button(@click="base.answer_create_handle" :type="{'is-primary': base.answer_turn_offset >= 1}" size="is-small")
          //-     | {{base.answer_turn_offset}}手目までの手順を正解とする

          //- .ox_buttons.is-flex.is-justify-content-center.my-4.has-addons
          //-   template(v-for="e in base.AnswerKindInfo.values")
          //-     b-button.is-outlined(:icon-left="e.icon" @click="base.next_handle(e)")

          WkbkBookShowOxButtons.mt-4(:base="base")

      .column.RightColumn(:key="base.current_article.key" v-if="base.answer_column_show")

        b-field.mb-0.mt-3
          template(v-for="(e, i) in base.current_article.moves_answers")
            b-radio-button(v-model="base.answer_tab_index" :native-value="i" size="is-small")
              span
                | {{i + 1}}

        template(v-for="(e, i) in base.current_article.moves_answers")
          .CustomShogiPlayerWrap(v-show="base.answer_tab_index === i")
            CustomShogiPlayer(
              v-bind="sp_bind"
              :sp_mobile_vertical="false"
              sp_mode="view"
              :sp_body="base.sfen_flop(base.current_article.init_sfen_with(e))"
              :sp_turn="0"
              :sp_viewpoint="base.current_viewpoint"
              sp_controller
              )
            .buttons.mb-0.is-centered.are-small.is-marginless.mt-4
              PiyoShogiButton.mb-0(:href="base.answers_piyo_shogi_app_with_params_url(e)")
              KentoButton.mb-0(tag="a" :href="base.answers_kento_app_with_params_url(e)" target="_blank")
              KifCopyButton.mb-0(@click="base.answers_kifu_copy_handle(e)") コピー

        template(v-if="base.current_article.description")
          .is-flex.is-justify-content-center.my-4(v-if="!base.description_open_p")
            b-button(@click="base.description_open_handle") 解説
          .box(v-if="base.description_open_p" v-html="$GX.simple_format($GX.auto_link(base.current_article.description))")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowSp",
  mixins: [support_child],

  computed: {
    // .column に指定するクラス
    // main_column_class() {
    //   const av = []
    //   av.push(`is_wb_mode_${this.base.sp_mode}`) // is_wb_mode_play, is_wb_mode_edit
    //   return av
    // },

    // CustomShogiPlayer に全部渡す
    sp_bind() {
      const hv = {}
      // hv.ref                         = "main_sp"
      // hv["class"]                    = this.base.sp_class

      // ここ以降 hv.sp_* = でないとおかしいので注意
      // hv.sp_mode                     = this.base.sp_mode
      // hv.sp_turn                     = this.base.current_turn
      // hv.sp_body                     = this.base.current_sfen
      // hv.sp_player_info              = this.base.sp_player_info
      // hv.sp_human_side               = this.base.sp_human_side
      // hv.sp_legal_move_only          = this.base.legal_strict_p
      // hv.sp_my_piece_only_move       = this.base.legal_strict_p
      // hv.sp_my_piece_kill_disabled = this.base.legal_strict_p
      // hv.sp_lift_cancel_action       = this.base.lift_cancel_action_info.key
      // hv.sp_layer                    = this.sp_layer
      // hv.sp_controller               = this.sp_controller
      // hv.sp_slider                   = this.sp_slider

      // if (!this.base.edit_mode_p) {
      hv.sp_piece_variant = this.base.appearance_theme_info.sp_piece_variant
      hv.sp_board_variant = this.base.appearance_theme_info.sp_board_variant

      return hv
    },

    // // 開発時だけレイヤーON
    // sp_layer() {
    //   return this.development_p
    // },

    // 動作を受け取るやつら
    sp_hook() {
      const hv = {}

      hv.ev_action_piece_lift     = this.TheApp.ev_action_piece_lift     // 意図して持ち上げた
      hv.ev_action_piece_cancel   = this.TheApp.ev_action_piece_cancel   // 意図してキャンセルした
      hv.ev_play_mode_move        = this.TheApp.ev_play_mode_move        // 自分が指したときの駒音 (画面にされるのは次のフレームなのでずらす)
      hv.ev_action_turn_change = this.TheApp.ev_action_turn_change // スライダーを自分が動かしたときの音
      hv.ev_action_viewpoint_flip = this.TheApp.ev_action_viewpoint_flip // ☗☖をタップして反転したときの音

      // hv["ev_play_mode_move"]              = this.base.ev_play_mode_move
      // hv["ev_edit_mode_short_sfen_change"] = this.base.ev_edit_mode_short_sfen_change
      // hv["ev_short_sfen_change"]           = this.base.ev_short_sfen_change
      // hv["ev_turn_offset_change"]          = v => this.base.current_turn = v
      // hv["ev_turn_offset_max_change"]      = v => this.base.turn_offset_max = v
      //
      // hv["ev_action_viewpoint_flip"]       = this.base.ev_action_viewpoint_flip // 意図して☗☖をタップして反転させたとき
      // hv["ev_action_turn_change"]          = this.base.ev_action_turn_change    // スライダーを動かしたとき
      // hv["ev_action_piece_lift"]           = this.base.ev_action_piece_lift     // 意図して持ち上げた
      // hv["ev_action_piece_cancel"]         = this.base.ev_action_piece_cancel   // 意図してキャンセルした
      //
      // // 手番 or 先後違い系
      // hv["ev_illegal_click_but_self_is_not_turn"] = this.base.ev_illegal_click_but_self_is_not_turn
      // hv["ev_illegal_my_turn_but_oside_click"]    = this.base.ev_illegal_my_turn_but_oside_click
      //
      // // 反則系
      // hv["ev_illegal_illegal_accident"] = this.base.ev_illegal_illegal_accident

      return hv
    },
  }
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
      margin-bottom: 3rem // 下を開けないと押しにくい

    display: flex
    align-items: center
    flex-direction: column

    .radio.button
      padding: 0 1.5rem

    .CustomShogiPlayerWrap
      +mobile
        margin-top: 0.5rem
      +tablet
        margin-top: 1.0rem

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
