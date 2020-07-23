<template lang="pug">
.question_author.has-text-centered
  .question_title.has-text-weight-bold.is-size-6(v-if="title_display_p && question.title")
    | {{question.title}}

  .direction_message.is-size-6(v-if="question.direction_message")
    | {{question.direction_message}}

  .question_user.has-text-weight-bold
    b-tag
      template(v-if="question.source_about_key === 'unknown'")
        | 作者不詳
      template(v-else)
        | {{question.display_author}}作

    b-tag.ml-1(v-if="question.ox_record.ox_total >= 1" size="is-medium")
      | 正解率
      span {{float_to_perc(question.ox_record.o_rate)}}%
</template>

<script>
import { support } from "../support.js"

export default {
  name: "question_author",
  mixins: [
    support,
  ],
  props: {
    title_display_p: { type: Boolean, required: false, default: true, },
    question:        { type: Object,  required: true,                 },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.question_author
  .question_title
  .question_user
    //- ↓これを入れると overflow-x が効かなくなる
    //- position: relative
    //- left: 0.1rem
</style>
