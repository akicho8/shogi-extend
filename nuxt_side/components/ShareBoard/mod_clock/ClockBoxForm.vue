<template lang="pug">
table.ClockBoxForm(:class="{cc_unique_p: SB.cc_unique_p}")
  thead
    tr
      th
      template(v-if="SB.cc_unique_p")
        th(v-for="(e, i) in SB.cc_params")
          | {{SB.Location.fetch(i).name}}
      template(v-else)
        th
          template(v-for="e in SB.Location.values")
            span {{e.name}}
  tbody
    template(v-for="e in SB.ClockAttrInfo.values")
      ClockBoxFormAttr(:clock_attr_info="e" :key="e.key")
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"
import { GX } from "@/components/models/gx.js"

export default {
  name: "ClockBoxForm",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../stylesheets/support"

.STAGE-development
  .ClockBoxForm
    td, th
      border: 1px dashed change_color($primary, $alpha: 0.5)

.ClockBoxForm
  width: stretch
  th
    font-size: $size-7
    white-space: nowrap
    font-weight: normal
    line-height: 1.0
    vertical-align: middle
  thead
    th
      text-align: center

  &.cc_unique_p
    tbody
      td
        width: 50%
</style>
