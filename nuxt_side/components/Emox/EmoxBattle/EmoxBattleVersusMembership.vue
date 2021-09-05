<template lang="pug">
.EmoxBattleVersusMembership.has-text-centered
  span.time_format.fixed_font.has-background-white-ter.px-3.py-3.is-size-3(v-if="base.clock_box")
    | {{base.membership_clock_time_format(membership)}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "EmoxBattleVersusMembership",
  mixins: [support_child],
  props: {
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
