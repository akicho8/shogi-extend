<template lang="pug">
.the_battle_sakusha.has-text-centered
  .question_title.has-text-weight-bold.is-size-5
    | {{app.c_quest.title}}
  .question_user.is-size-7.has-text-weight-bold
    | {{app.c_quest.display_author}}
    span.question_user_unit.has-text-grey 作
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_battle_sakusha",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "../support.sass"
.the_battle_sakusha
  .question_title
  .question_user
    position: relative
    left: 0.1rem
    .question_user_unit
      margin-left: 0.1rem
      font-size: 0.6rem
</style>
