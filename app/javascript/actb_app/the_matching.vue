<template lang="pug">
.the_matching.columns.is-paddingless
  .column
    .has-text-centered.has-text-weight-bold
      .wait_notification
        | 対戦相手を待機中
      p {{app.matching_interval_timer_count}}
      p ±{{app.matching_rate_threshold}}

    b-progress.mt-2(type="is-primary")

    .buttons.is-centered.mt-2
      button.delete.is-large(@click="app.matching_cancel_handle")
    the_lobby_debug
</template>

<script>
import { support } from "./support.js"
import the_lobby_debug from "./the_lobby_debug.vue"

export default {
  name: "the_matching",
  components: {
  the_lobby_debug
  },
  mixins: [
    support,
  ],
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
  .progress
    animation-duration: 3.0s
    width: 16rem
    margin: auto
</style>
