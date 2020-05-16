<template lang="pug">
.the_history_vote.is-flex.is-unselectable
  .thumb_box.good(@click="$parent.vote_handle(row, 'good', !row.good_mark_on)" :class="{'has-text-primary': row.good_mark_on}")
    b-icon(:icon="row.good_mark_on ? 'thumb-up' : 'thumb-up-outline'")
    span.marks_count
      | {{row.question.good_marks_count}}
  .thumb_box.bad(@click="$parent.vote_handle(row, 'bad', !row.bad_mark_on)" :class="{'has-text-primary': row.bad_mark_on}")
    b-icon(:icon="row.bad_mark_on ? 'thumb-down' : 'thumb-down-outline'")
    span.marks_count
      | {{row.question.bad_marks_count}}
</template>

<script>
import support from "./support.js"

export default {
  name: "the_history_vote",
  mixins: [
    support,
  ],
  props: {
    row: { required: true },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_history_vote
  .thumb_box
    &.bad
      margin-left: 1rem
    cursor: pointer
    color: $grey-light
    .marks_count
      margin-left: 0.5rem
      vertical-align: top
</style>
