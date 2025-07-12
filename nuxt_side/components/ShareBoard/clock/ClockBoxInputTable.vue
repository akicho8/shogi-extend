<template lang="pug">
table.ClockBoxInputTable(:class="{cc_unique_p: SB.cc_unique_p}")
  thead
    tr
      th
      template(v-if="SB.cc_unique_p")
        th(v-for="(e, i) in SB.cc_params")
          | {{Location.fetch(i).name}}
      template(v-else)
        th
          | ☗ ☖
  tbody
    tr
      th 持ち時間(分)
      td(v-for="e in SB.cc_params")
        b-numberinput.initial_main_min(v-bind="input_default_attrs" v-model="e.initial_main_min" :max="60*6" @input="SB.cc_input_handle")
    tr
      th 秒読み
      td(v-for="e in SB.cc_params")
        b-numberinput.initial_read_sec(v-bind="input_default_attrs" v-model="e.initial_read_sec" :max="60*60" @input="SB.cc_input_handle")
    tr
      th
        //- https://buefy.org/documentation/tooltip
        b-tooltip(position="is-right" multilined type="is-light" dashed)
          template(v-slot:content)
            //- p.title.is-6.mb-0 深考時間とは？
            .is-flex.is-flex-direction-column
              p 秒読みが0になった後に使える、回復しない持ち時間です
              p 切れ負け防止用ではなく<b>勝負所でじっくり考える</b>ための時間です
              p <b>分単位</b>で設定すると内容の濃い対局になるでしょう
          //- span.has-text-weight-bold
          | 深考時間(秒)
          //- b-icon.has-text-info(icon="help-circle-outline" size="is-small")
      td(v-for="e in SB.cc_params")
        b-numberinput.initial_extra_sec(v-bind="input_default_attrs" v-model="e.initial_extra_sec" :max="60*60" @input="SB.cc_input_handle")
    tr
      th 1手毎加算(秒)
      td(v-for="e in SB.cc_params")
        b-numberinput.every_plus(v-bind="input_default_attrs" v-model="e.every_plus" :max="60*60" @input="SB.cc_input_handle")
</template>

<script>
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "ClockBoxInputTable",
  mixins: [support_child],
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
@import "../sass/support.sass"

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

  // ツールチップ左寄せ
  .b-tooltip.is-multiline
    .tooltip-content
      padding: 1rem
      width: 15rem

      text-align: left
      line-height: 1.5

      .is-flex
        gap: 0.75rem

      // .title
      //   color: inherit
      //   white-space: nowrap
</style>
