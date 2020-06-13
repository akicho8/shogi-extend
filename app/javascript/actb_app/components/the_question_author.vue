<template lang="pug">
.the_question_author.has-text-centered
  .question_title.has-text-weight-bold.is-size-6
    | {{question.title}}
  .question_user.is-size-7.has-text-weight-bold
    span.is-unselectable
      | &nbsp;&nbsp;&nbsp;&nbsp;
    span
      | {{question.display_author}}
    span.question_user_unit.has-text-grey 作
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
    .question_user_unit
      margin-left: 0.1rem
      font-size: 0.6rem
</style>
