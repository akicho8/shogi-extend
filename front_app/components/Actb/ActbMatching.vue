<template lang="pug">
.ActbMatching
  .primary_header
    b-icon.header_item.with_icon.ljust(icon="chevron-left" @click.native="base.matching_cancel_handle")
    .header_center_title 対戦相手を待機中

  .progress_container.has-text-centered
    b-progress(type="is-primary" size="is-small")

  .has-text-centered.has-text-weight-bold.mt-3(v-if="base.debug_read_p")
    div {{base.matching_interval_timer_count}}
    div ±{{base.matching_rate_threshold}}

  ActbLobbyDebug(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ActbMatching",

  mixins: [
    support_child,
  ],
  beforeDestroy() {
    this.base.matching_interval_timer_clear()
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ActbMatching
  @extend %padding_top_for_primary_header
  .progress_container
    margin: 3rem 3rem
    .progress
      animation-duration: 4.0s
      width: 100%
</style>
