<template lang="pug">
.the_history_row_vote.is-flex.is-unselectable
  .icon_with_counter.good(@click.stop="base.vote_handle(row, 'good', !row.good_p)" :class="{'has-text-primary': row.good_p}")
    b-icon(size="is-small" :icon="row.good_p ? 'thumb-up' : 'thumb-up-outline'")
    span.icon_counter {{row.question.good_marks_count}}

  .icon_with_counter.bad(@click.stop="base.vote_handle(row, 'bad', !row.bad_p)" :class="{'has-text-primary': row.bad_p}")
    b-icon(size="is-small" :icon="row.bad_p ? 'thumb-down' : 'thumb-down-outline'")
    span.icon_counter {{row.question.bad_marks_count}}

  .icon_with_counter.clip(@click.stop="base.clip_handle(row, !row.clip_p)" :class="{'has-text-gold': row.clip_p}")
    b-icon(size="is-small" :icon="row.clip_p ? 'star' : 'star-outline'")
    span.icon_counter(v-if="development_p") {{row.question.clip_marks_count}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "the_history_row_vote",
  mixins: [
    support_child,
  ],
  props: {
    row:  { required: true  },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_history_row_vote
  .icon_with_counter
    @extend %icon_with_counter
    &.good
      margin-left: 0.0rem
    &.bad
      margin-left: 0.2rem
    &.clip
      margin-left: 0.8rem
</style>
