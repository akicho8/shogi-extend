<template lang="pug">
.the_question_show.modal-card
  .modal-card-body.box
    //- // 自分で閉じるボタン設置。組み込みのはもともとフルスクリーンを考慮しておらず、白地に白いボタンで見えないため。
    .delete.is-large(@click="delete_click_handle")

    question_author(:question="new_ov_question_info.question")

    .secondary_header
      b-tabs(v-model="tab_index" @change="tab_change_handle" expanded)
        b-tab-item(label="初期配置")
        template(v-for="(e, i) in new_ov_question_info.question.moves_answers")
          b-tab-item(:label="`${i === 0 ? '解' : ''}${i + 1}`")

    .sp_container
      shogi_player(
        :run_mode="'play_mode'"
        :kifu_body="selected_sfen"
        :start_turn="-1"
        :key_event_capture="false"
        :slider_show="true"
        :controller_show="true"
        :setting_button_show="false"
        :theme="'simple'"
        :size="'default'"
        :sound_effect="true"
        :volume="0.5"
        @update:play_mode_advanced_moves="play_mode_advanced_moves_set"
        )

    .vote_container.is-flex
      the_history_row_vote(:row="new_ov_question_info")

    the_question_show_message(:question="new_ov_question_info.question")
</template>

<script>
import { support } from "./support.js"
import the_history_row_vote      from "./the_history/the_history_row_vote.vue"
import the_question_show_message from "./the_question_show_message.vue"
import question_author       from "./components/question_author.vue"

export default {
  name: "the_question_show",
  mixins: [
    support,
  ],
  props: {
    ov_question_info: { type: Object, required: true },
  },
  components: {
    the_history_row_vote,
    the_question_show_message,
    question_author,
  },
  data() {
    return {
      tab_index: 0,
      new_ov_question_info: this.ov_question_info,
    }
  },
  created() {
  },
  methods: {
    delete_click_handle() {
      this.sound_play("click")
      this.$emit("close")
    },

    tab_change_handle() {
      // this.sound_play("click")
    },

    play_mode_advanced_moves_set(moves) {
      if (this.new_ov_question_info.question.moves_valid_p(moves)) {
        this.sound_play("o")
        this.ok_notice("正解")
      }
    },

    // 指定インデックスの解のSFENを返す
    answer_sfen_for(index) {
      return this.new_ov_question_info.question.answer_sfen_list[index]
    },
  },
  computed: {
    selected_sfen() {
      if (this.tab_index === 0) {
        return this.new_ov_question_info.question.init_sfen
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
  &.modal-card
    .modal-card-body
      padding: 1rem 0

    .question_title
      margin-left: 0.3rem

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
            margin-left: 1.5rem
          &.clip
            margin-left: 2rem
</style>
