<template lang="pug">
.the_builder_seikai
  shogi_player(
    :run_mode="'play_mode'"
    :kifu_body="$parent.question.init_sfen"
    :flip_if_white="true"
    :start_turn="0"
    :key_event_capture="false"
    :slider_show="true"
    :controller_show="true"
    :setting_button_show="false"
    :theme="'simple'"
    :size="'default'"
    :sound_effect="true"
    :volume="0.5"
    @update:turn_offset="$parent.turn_offset_set"
    @update:mediator_snapshot_sfen="$parent.mediator_snapshot_sfen_set"
    ref="play_sp"
    )

  .buttons.is-centered.konotejunsiikai
    b-button(@click="$parent.edit_stock_handle" :type="{'is-primary': $parent.answer_turn_offset >= 1}")
      | {{$parent.answer_turn_offset}}手目までの手順を正解とする

  b-tabs.answer_tabs(v-model="$parent.answer_tab_index" position="is-centered" expanded :animated="false" v-if="$parent.question.moves_answers.length >= 1" @change="sound_play('click')")
    template(v-for="(e, i) in $parent.question.moves_answers")
      b-tab-item(:label="`${i + 1}`" :key="`tab_${i}_${e.moves_str}`")
        shogi_player(
          :run_mode="'view_mode'"
          :kifu_body="$parent.full_sfen_build(e)"
          :flip_if_white="true"
          :start_turn="-1"
          :debug_mode="false"
          :key_event_capture="false"
          :slider_show="true"
          :controller_show="true"
          :setting_button_show="false"
          :theme="'simple'"
          :size="'default'"
          :sound_effect="true"
          :volume="0.5"
          )
        .delete_button.is_clickable(@click="$parent.moves_answer_delete_handle(i)")
          b-icon(type="is-danger" icon="trash-can-outline" size="is-small")
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_builder_seikai",
  mixins: [
    support,
  ],
  created() {
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_builder_seikai
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
