<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | お題作成
      span.mx-1.has-text-grey.has-text-weight-normal(v-if="SB.debug_mode_p")
        | (ID:{{SB.master_quiz.unique_code}})
    a.quiz_source_random_handle.is-unselectable(@click="quiz_source_random_handle")
      | 🦉
  .modal-card-body
    b-field(label-position="on-border")
      template(#label)
        | お題
        span.mx-1(class="has-text-grey" v-if="false") 例: {{example.subject}}
      b-input.quiz_subject(v-model="SB.master_quiz.subject" :placeholder="example.subject" ref="subject_input_tag")
    b-field(grouped)
      b-field(label="選択肢1" label-position="on-border")
        b-input.quiz_left(v-model="SB.master_quiz.left_value" :placeholder="example.left_value" expanded)
      b-field(label="選択肢2" label-position="on-border")
        b-input.quiz_right(v-model="SB.master_quiz.right_value" :placeholder="example.right_value" expanded)
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button(@click="submit_handle" type="is-primary")
      | 出題する
      //- template(v-if="SB.quiz_new_p") 送信する
      //- template(v-if="SB.quiz_persisted_p") 再送信する
</template>

<script>
import _ from "lodash"

const VALIDATION_ON = false
import { support_child } from "../support_child.js"

export default {
  name: "QuizMakerModal",
  mixins: [support_child],
  mounted() {
    this.input_focus()
  },
  methods: {
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
    submit_handle() {
      this.sfx_click()
      if (VALIDATION_ON) {
        if (this.SB.master_quiz.invalid_p) {
          this.toast_warn("ぜんぶ入力しよう")
          return
        }
      }
      this.SB.quiz_share(this.SB.master_quiz)
      this.$emit("close")
    },
    // お題名が空のときかつデスクトップならフォーカスする
    input_focus() {
      if (this.$GX.blank_p(this.SB.master_quiz.subject)) {
        this.desktop_focus_to(this.$refs.subject_input_tag)
      }
    },
    quiz_source_random_handle() {
      this.SB.quiz_source_random_handle()
    },
  },
  computed: {
    example() {
      return _.sample([
        { subject: "どっちがお好き？",                   left_value: "マヨネーズ",       right_value: "ケチャップ",      },
        // { subject: "アナタはどっち派？ドラゴンクエスト", left_value: "ガンガンいこうぜ", right_value: "いのちだいじに",  },
      ])
    },
  },
}
</script>

<style lang="sass">
@import "../scss/support"

.QuizMakerModal
  +modal_max_width(30rem)

  .modal-card-body
    padding: 1.5rem
    display: flex
    flex-direction: column
    gap: 0.75rem
    .field.is-grouped
      gap: 1rem
      .field
        flex-shrink: 1
        width: 100%
        margin: 0

  .modal-card-foot
    .button
      min-width: 6rem

.STAGE-development
  .QuizMakerModal
    __css_keep__: 0
</style>
