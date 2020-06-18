<template lang="pug">
.the_question_author.has-text-centered
  .question_title.has-text-weight-bold.is-size-6
    | {{question.title}}

  .question_user.is-size-9.has-text-grey
    span {{question.display_author}}
    span.is-size-11 作

    span.has-text-grey.ml-2 正解率
    span {{float_to_perc2(question.ox_record.o_rate)}}
    span %

</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_question_author",
  mixins: [
    support,
  ],
  props: {
    question: { type: Object, required: true },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_question_author
  .question_title
  .question_user
    //- ↓これを入れると overflow-x が効かなくなる
    //- position: relative
    //- left: 0.1rem
</style>
