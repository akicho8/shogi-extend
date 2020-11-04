<template lang="pug">
.EmoxBattleVersusMembership.has-text-centered
  span.time_format.fixed_font.has-background-white-ter.px-3.py-3.is-size-3(v-if="base.chess_clock")
    | {{base.chess_clock.single_clocks[membership.position].to_time_format}}
</template>

<script>
import { support } from "../support.js"

export default {
  name: "EmoxBattleVersusMembership",
  mixins: [
    support,
  ],
  props: {
    base: { type: Object, required: true, },
    membership: { type: Object,  required: true, },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.EmoxBattleVersusMembership
  .time_format
    border-radius: 0.5rem
</style>
