<template lang="pug">
.EmoxMatching
  MainNavbar
    template(slot="brand")
      b-navbar-item(@click.native="base.matching_cancel_handle")
        b-icon(icon="chevron-left")
      b-navbar-item.has-text-weight-bold(tag="div") 対戦相手を待機中
  MainSection
    .container
      .columns
        .column
          .progress_container.has-text-centered
            b-progress(type="is-primary" size="is-small")

          .has-text-centered.has-text-weight-bold.mt-3(v-if="development_p")
            div {{base.matching_interval_timer_count}}
            div ±{{base.matching_rate_threshold}}

  EmoxMatchingOperation(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "EmoxMatching",
  mixins: [support_child],
  beforeDestroy() {
    this.base.matching_interval_timer_clear()
  },
}
</script>

<style lang="sass">
@import "support.sass"
.EmoxMatching
  .progress_container
    margin: 3rem 3rem
    .progress
      animation-duration: 4.0s
      width: 100%
</style>
