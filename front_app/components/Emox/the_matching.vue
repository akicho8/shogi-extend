<template lang="pug">
.the_matching
  .primary_header
    b-icon.header_item.with_icon.ljust(icon="chevron-left" @click.native="app.matching_cancel_handle")
    .header_center_title 対戦相手を待機中

  .progress_container.has-text-centered
    b-progress(type="is-primary" size="is-small")

  .has-text-centered.has-text-weight-bold.mt-3(v-if="app.debug_read_p")
    div {{app.matching_interval_timer_count}}
    div ±{{app.matching_rate_threshold}}

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
  @extend %padding_top_for_primary_header
  .progress_container
    margin: 3rem 3rem
    .progress
      animation-duration: 4.0s
      width: 100%
</style>
