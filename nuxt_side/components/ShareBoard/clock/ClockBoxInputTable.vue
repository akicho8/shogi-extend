<template lang="pug">
table.ClockBoxInputTable(:class="{cc_unique_p: TheSb.cc_unique_p}")
  thead
    tr
      th
      template(v-if="TheSb.cc_unique_p")
        th(v-for="(e, i) in TheSb.cc_params")
          | {{Location.fetch(i).name}}
      template(v-else)
        th
          | ☗☖
  tbody
    tr
      th 持ち時間(分)
      td(v-for="e in TheSb.cc_params")
        b-numberinput.initial_main_min(v-bind="input_default_attrs" v-model="e.initial_main_min" :max="60*6" @input="TheSb.cc_input_handle")
    tr
      th 秒読み
      td(v-for="e in TheSb.cc_params")
        b-numberinput.initial_read_sec(v-bind="input_default_attrs" v-model="e.initial_read_sec" :max="60*60" @input="TheSb.cc_input_handle")
    tr
      th 猶予(秒)
      td(v-for="e in TheSb.cc_params")
        b-numberinput.initial_extra_sec(v-bind="input_default_attrs" v-model="e.initial_extra_sec" :max="60*60" @input="TheSb.cc_input_handle")
    tr
      th 1手毎加算(秒)
      td(v-for="e in TheSb.cc_params")
        b-numberinput.every_plus(v-bind="input_default_attrs" v-model="e.every_plus" :max="60*60" @input="TheSb.cc_input_handle")
</template>

<script>
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export default {
  name: "ClockBoxInputTable",
  inject: ["TheSb"],
  computed: {
    Location() { return Location },
    input_default_attrs() {
      return {
        "min": 0,
        "expanded": true,
        "size": "is-small",
        "controls-position": "compact",
        "exponential": true,
      }
    },
  },

}
</script>

<style lang="sass">
@import "../support.sass"

.STAGE-development
  .ClockBoxInputTable
    td, th
      border: 1px dashed change_color($primary, $alpha: 0.5)

.ClockBoxInputTable
  width: 100%
  th
    font-size: $size-7
    white-space: nowrap
    font-weight: normal
    line-height: 1.0
    vertical-align: middle
  thead
    th
      text-align: center
  tbody
    th
      width: 0%
      text-align: right
      padding: 0 0.5rem
    td
      width: 100%
      padding: 0.25rem

  &.cc_unique_p
    tbody
      td
        width: 50%
</style>
