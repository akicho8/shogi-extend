<template lang="pug">
.ActbQuestionAuthor.has-text-centered
  .question_title.has-text-weight-bold.is-size-6(v-if="title_display_p && question.title")
    | {{question.title}}

  .direction_message.is-size-6(v-if="question.direction_message")
    | {{question.direction_message}}

  .question_user
    b-tag.mx-1
      template(v-if="question.source_about_key === 'unknown'")
        | 作者不詳
      template(v-else)
        span.has-text-weight-bold
          | {{question.display_author}}
        | 作

    b-tag.mx-1(v-if="question.ox_record.ox_total >= 1")
      | 正解率
      span.has-text-weight-bold.mx-1 {{float_to_perc(question.ox_record.o_rate)}}
      | %
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ActbQuestionAuthor",
  mixins: [
    support_child,
  ],
  props: {
    title_display_p: { type: Boolean, required: false, default: true, },
    question:        { type: Object,  required: true,                 },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbQuestionAuthor
  .question_title
  .question_user
    //- ↓これを入れると overflow-x が効かなくなる
    //- position: relative
    //- left: 0.1rem
</style>
