<template lang="pug">
.the_history_row_vote.is-flex.is-unselectable
  .vote_block.good(@click="$parent.$parent.vote_handle(row, 'good', !row.good_p)" :class="{'has-text-primary': row.good_p}")
    b-icon(:icon="row.good_p ? 'thumb-up' : 'thumb-up-outline'")
    span.icon_counter
      | {{row.question.good_marks_count}}
  .vote_block.bad(@click="$parent.$parent.vote_handle(row, 'bad', !row.bad_p)" :class="{'has-text-primary': row.bad_p}")
    b-icon(:icon="row.bad_p ? 'thumb-down' : 'thumb-down-outline'")
    span.icon_counter
      | {{row.question.bad_marks_count}}
</template>

<script>
import support from "./support.js"

export default {
  name: "the_history_row_vote",
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
.the_history_row_vote
  .vote_block
    &.bad
      margin-left: 1.24rem
    @extend %icon_with_counter
</style>
