<template lang="pug">
.the_matching.columns.is-paddingless
  .column
    .has-text-centered.has-text-weight-bold
      .wait_notification
        | 対戦相手を待機中
      p {{interval_timer_count}}
      p ±{{matching_rate_threshold}}
    b-progress(type="is-primary")
    .buttons.is-centered
      button.delete.is-large(@click="app.cancel_handle")
</template>

<script>
import support from "./support.js"
import the_matching_interval from './the_matching_interval.js'

export default {
  name: "the_matching",
  mixins: [
    support,
    the_matching_interval,
  ],
  props: {
    info: { required: true },
  },
  created() {
    this.matching_init()
  },
  beforeDestroy() {
    this.interval_timer_clear()
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_matching
  .wait_notification
    padding: 1rem 0
</style>
