<template lang="pug">
.the_builder_edit_seikai
  MyShogiPlayer(
    :run_mode="'play_mode'"
    :kifu_body="bapp.question.init_sfen"
    :flip_if_white="true"
    :start_turn="0"
    :key_event_capture="false"
    :slider_show="true"
    :controller_show="true"
    :setting_button_show="false"
    :theme="'simple'"
    :size="'default'"
    @update:turn_offset="bapp.turn_offset_set"
    @update:mediator_snapshot_sfen="bapp.mediator_snapshot_sfen_set"
    ref="main_sp"
    )

  .buttons.is-centered.konotejunsiikai
    b-button(@click="bapp.edit_stock_handle" :type="{'is-primary': bapp.answer_turn_offset >= 1}")
      | {{bapp.answer_turn_offset}}手目までの手順を正解とする

  b-tabs.answer_tabs(v-model="bapp.answer_tab_index" position="is-centered" expanded :animated="false" v-if="bapp.question.moves_answers.length >= 1" @input="sound_play('click')")
    template(v-for="(e, i) in bapp.question.moves_answers")
      b-tab-item(:label="`${i + 1}`" :key="`tab_${i}_${e.moves_str}`")
        MyShogiPlayer(
          :run_mode="'view_mode'"
          :kifu_body="bapp.full_sfen_build(e)"
          :flip_if_white="true"
          :start_turn="-1"
          :debug_mode="false"
          :key_event_capture="false"
          :slider_show="true"
          :controller_show="true"
          :setting_button_show="false"
          :theme="'simple'"
          :size="'default'"
          )
        .delete_button.is-clickable(@click="bapp.moves_answer_delete_handle(i)")
          b-icon(type="is-danger" icon="trash-can-outline" size="is-small")
</template>

<script>
import { builder_support } from "./builder_support.js"

export default {
  name: "the_builder_edit_seikai",
  mixins: [
    builder_support,
  ],
  created() {
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_builder_edit_seikai
  margin-top: 1.5rem
  margin-bottom: $margin_bottom

  // この手順を正解にする
  .konotejunsiikai
    margin-top: 0.3rem

  // 正解のタブ
  .answer_tabs
    margin-top: 0.8rem
    .tab-content
      padding-top: 1.3rem
      position: relative
      .delete_button
        margin-top: 0.5rem
        margin-left: 0.5rem
</style>
