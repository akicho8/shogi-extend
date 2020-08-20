<template lang="pug">
.the_builder_edit_seikai
  shogi_player(
    :run_mode="'play_mode'"
    :kifu_body="question.init_sfen"
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
    @update:turn_offset="turn_offset_set"
    @update:mediator_snapshot_sfen="mediator_snapshot_sfen_set"
    ref="play_sp"
    )

  .buttons.is-centered.konotejunsiikai
    b-button(@click="edit_stock_handle({moves: current_moves()})" :type="{'is-primary': answer_turn_offset >= 1}")
      | {{answer_turn_offset}}手目までの手順を正解とする

  b-tabs.answer_tabs(v-model="$store.state.builder.answer_tab_index" position="is-centered" expanded :animated="false" v-if="question.moves_answers.length >= 1" @change="sound_play('click')")
    template(v-for="(e, i) in question.moves_answers")
      b-tab-item(:label="`${i + 1}`" :key="`tab_${i}_${e.moves_str}`")
        shogi_player(
          :run_mode="'view_mode'"
          :kifu_body="full_sfen_build(e)"
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
        .delete_button.is_clickable(@click="moves_answer_delete_handle(i)")
          b-icon(type="is-danger" icon="trash-can-outline" size="is-small")
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_builder_edit_seikai",
  mixins: [
    support,
  ],
  methods: {
    current_moves() {
      return this.$refs.play_sp.moves_take_turn_offset
    },
    full_sfen_build(moves_answer_attributes) {
      return [this.question.init_sfen, "moves", moves_answer_attributes.moves_str].join(" ")
    },
    moves_answer_delete_handle(index) {
      const new_ary = this.question.moves_answers.filter((e, i) => i !== index)
      this.$set(this.$store.state.builder.question, "moves_answers", new_ary)
      const new_index = _.clamp(this.answer_tab_index, 0, this.question.moves_answers.length - 1)
      this.$nextTick(() => this.$store.state.builder.answer_tab_index = new_index)
      this.sound_play("click")
      this.ok_notice("削除しました")
    },
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
