<template lang="pug">
.the_matching.columns.is-paddingless
  .column
    .has-text-centered.has-text-weight-bold
      .wait_notification
        | 対戦相手を待機中
      p {{app.matching_interval_timer_count}}
      p ±{{app.matching_rate_threshold}}
    b-progress(type="is-primary")
    .buttons.is-centered
      button.delete.is-large(@click="app.cancel_handle")
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_matching",
  mixins: [
    support,
  ],
  created() {
    this.app.matching_init()
  },
  beforeDestroy() {
    this.app.matching_interval_timer_clear()
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_matching
  .wait_notification
    padding: 1rem 0
</style>
