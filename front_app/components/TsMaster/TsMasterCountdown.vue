<template lang="pug">
.TsMasterCountdown(@click.prevent.stop.capture v-if="base.mode === 'is_mode_ready'")
  .contdown_value
    | {{base.countdown}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "TsMasterCountdown",
  mixins: [support_child],
}
</script>

<style lang="sass">
.STAGE-development
  .TsMasterCountdown
    border: 1px dashed change_color($primary, $alpha: 0.5)

.TsMasterCountdown
  z-index: 2
  @extend %overlay
  // margin: auto

  display: flex
  justify-content: center
  align-items: center

  .contdown_value
    font-size: 24rem
    color: $primary
    -webkit-text-stroke: 1px $white
    text-shadow: change_color($black, $alpha: 0.1) 0px 0px 8px
</style>
