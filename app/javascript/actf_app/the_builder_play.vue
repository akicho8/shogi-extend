<template lang="pug">
.the_builder_play
  shogi_player(
    :run_mode="'play_mode'"
    :kifu_body="position_sfen_add($parent.$parent.$parent.question.init_sfen)"
    :start_turn="0"
    :key_event_capture="false"
    :slider_show="true"
    :controller_show="true"
    :setting_button_show="false"
    :theme="'simple'"
    :size="'default'"
    :sound_effect="$parent.$parent.$parent.edit_tab_info.key === 'play_mode'"
    :volume="0.5"
    @update:turn_offset="$parent.$parent.$parent.turn_offset_set"
    @update:mediator_snapshot_sfen="$parent.$parent.$parent.mediator_snapshot_sfen_set"
    ref="play_sp"
    )

  .buttons.is-centered.konotejunsiikai
    b-button(@click="$parent.$parent.$parent.edit_stock_handle" :type="{'is-primary': $parent.$parent.$parent.answer_turn_offset >= 1}")
      | {{$parent.$parent.$parent.answer_turn_offset}}手目までの手順を正解とする
    //- b-button(@click="$parent.$parent.$parent.edit_stock2_handle" :type="{'is-primary': $parent.$parent.$parent.answer_turn_offset >= 1}") この手順を正解とする2

  b-tabs.answer_tabs(v-model="$parent.$parent.$parent.answer_tab_index" position="is-centered" expanded :animated="true" v-if="$parent.$parent.$parent.question.moves_answers.length >= 1")
    template(v-for="(e, i) in $parent.$parent.$parent.question.moves_answers")
      b-tab-item(:label="`${i + 1}`" :key="`tab_${i}_${e.moves_str}`")
        shogi_player(
          :run_mode="'view_mode'"
          :kifu_body="$parent.$parent.$parent.full_sfen_build(e)"
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
        b-button.delete_button(type="is-danger" icon-left="trash-can-outline" @click="$parent.$parent.$parent.kotae_delete_handle(i)" size="is-small")
</template>

<script>
import support from "./support.js"

export default {
  name: "the_builder_play",
  mixins: [
    support,
  ],
  created() {
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_builder_play
</style>
