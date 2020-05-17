<template lang="pug">
.the_question_show
  .primary_header
    .header_center_title
      | {{app.overlay_record.question.title}}
    b-icon.header_link_icon.ljust(icon="arrow-left" @click.native="app.board_close")
  .secondary_header
    b-tabs.main_tabs(v-model="tab_index" expanded @change="tab_change_handle")
      b-tab-item(label="初期配置")
      template(v-for="(e, i) in app.overlay_record.question.moves_answers")
        b-tab-item(:label="`${i === 0 ? '解' : ''}${i + 1}`")

  .sp_container
    shogi_player(
      :run_mode="'play_mode'"
      :kifu_body="selected_sfen"
      :start_turn="-1"
      :key_event_capture="false"
      :slider_show="true"
      :controller_show="true"
      :setting_button_show="development_p"
      :theme="'simple'"
      :size="'default'"
      :sound_effect="true"
      :volume="0.5"
      @update:play_mode_advanced_moves="play_mode_advanced_moves_set"
      )

  .vote_container.is-flex
    the_history_row_vote(:row="app.overlay_record")
</template>

<script>
import support from "./support.js"
import the_history_row_vote from "./the_history_row_vote.vue"

export default {
  name: "the_question_show",
  mixins: [
    support,
  ],
  components: {
    the_history_row_vote,
  },
  data() {
    return {
      tab_index: 0,
    }
  },
  methods: {
    tab_change_handle() {
      // this.sound_play("click")
    },

    play_mode_advanced_moves_set(moves) {
      if (this.app.overlay_record.question.moves_answers.some(e => e.moves_str === moves.join(" "))) {
        this.sound_play("o")
        this.ok_notice("正解")
      }
    },

    answer_sfen_for(index) {
      return [this.init_sfen, "moves", this.app.overlay_record.question.moves_answers[index].moves_str].join(" ")
    },
  },
  computed: {
    init_sfen() {
      return ["position", "sfen", this.app.overlay_record.question.init_sfen].join(" ")
    },
    selected_sfen() {
      if (this.tab_index === 0) {
        return this.init_sfen
      } else {
        return this.answer_sfen_for(this.tab_index - 1)
      }
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_question_show
  @extend %padding_top_for_secondary_header
  .primary_header
    justify-content: space-between

  .secondary_header
    .main_tabs
      a
        height: $actf_primary_header_height
        padding: 0
      .tab-content
        padding: 0

  .sp_container
    margin-top: 1.5rem

  .vote_container
    margin-top: 1.5rem
    justify-content: center

    .the_history_row_vote
      .icon_with_counter
        &.bad
          margin-left: 2rem
        &.clip
          margin-left: 5rem
</style>
