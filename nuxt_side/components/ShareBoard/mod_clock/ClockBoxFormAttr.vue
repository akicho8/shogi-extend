<template lang="pug">
tr.ClockBoxFormAttr
  th
    //- https://buefy.org/documentation/tooltip
    b-tooltip(position="is-right" multilined type="is-light" dashed)
      template(v-slot:content)
        .is-flex.is-flex-direction-column(v-html="clock_attr_info.tooltip")
      span(v-html="clock_attr_info.th_label")
  td(v-for="e in SB.cc_params")
    b-numberinput(
      v-bind="input_default_attrs"
      :value="e[clock_attr_info.key]"
      @input="v => input_handle(e, v)"
    )
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"
import { GX } from "@/components/models/gx.js"

export default {
  name: "ClockBoxFormAttr",
  mixins: [support_child],
  props: ["clock_attr_info"],
  methods: {
    input_handle(e, str) {
      let v = GX.to_i(str)
      if (false) {
        v = GX.iclamp(v, 0, this.clock_attr_info.max)
      }
      e[this.clock_attr_info.key] = v
      this.SB.cc_input_handle()
    },
  },
  computed: {
    // https://buefy.org/documentation/numberinput
    input_default_attrs() {
      return {
        "class": this.clock_attr_info.key,
        "min": 0,
        "max": this.clock_attr_info.max,
        "expanded": true,
        "size": "is-small",
        "controls-position": "compact",
        "exponential": true,
        "editable": this.development_p || true,
      }
    },
  },
}
</script>

<style lang="sass">
@import "../scss/support"

.ClockBoxFormAttr
  th
    width: 0%
    text-align: right
    padding: 0 0.5rem
  td
    width: 100%
    padding: 0.25rem

  // ツールチップ左寄せ
  .b-tooltip.is-multiline
    .tooltip-content
      padding: 1rem
      width: 15rem
      text-align: left
      line-height: 1.5
      .is-flex
        gap: 0.75rem

.STAGE-development
  .ClockBoxFormAttr
    td, th
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
