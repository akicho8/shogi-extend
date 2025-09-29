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
      th
        //- https://buefy.org/documentation/tooltip
        b-tooltip(position="is-right" multilined type="is-light" dashed)
          template(v-slot:content)
            .is-flex.is-flex-direction-column
              p 秒読みに入る前の持ち時間です
          | 持ち時間(分)
      td(v-for="e in SB.cc_params")
        b-numberinput.initial_main_min(v-bind="input_default_attrs" v-model="e.initial_main_min" :max="60" @input="SB.cc_input_handle")
    tr
      th
        //- https://buefy.org/documentation/tooltip
        b-tooltip(position="is-right" multilined type="is-light" dashed)
          template(v-slot:content)
            .is-flex.is-flex-direction-column
              p 毎回、回復する持ち時間です
          | 秒読み
      td(v-for="e in SB.cc_params")
        b-numberinput.initial_read_sec(v-bind="input_default_attrs" v-model="e.initial_read_sec" :max="60*5" @input="SB.cc_input_handle")
    tr
      th
        //- https://buefy.org/documentation/tooltip
        b-tooltip(position="is-right" multilined type="is-light" dashed)
          template(v-slot:content)
            .is-flex.is-flex-direction-column
              p 秒読みが切れた後の持ち時間です
              p
                | 勝負どころのための時間であり、切れ負け防止用の猶予ではありません
                | （秒読み自体がすでに猶予のため、これを猶予とみなすと双方の意味がなくなってしまう）
          | 考慮時間(分)
      td(v-for="e in SB.cc_params")
        b-numberinput.initial_extra_min(v-bind="input_default_attrs" v-model="e.initial_extra_min" :max="60" @input="SB.cc_input_handle")
    tr.is_separator
      th
      td(v-for="e in SB.cc_params")
    tr
      th
        //- https://buefy.org/documentation/tooltip
        b-tooltip(position="is-right" multilined type="is-light" dashed)
          template(v-slot:content)
            .is-flex.is-flex-direction-column
              p これを設定するときは<b>秒読み</b>と<b>考慮時間</b>を 0 にするのをおすすめします
          | 1手毎加算(秒)
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

    // https://buefy.org/documentation/numberinput
    input_default_attrs() {
      return {
        "min": 0,
        "expanded": true,
        "size": "is-small",
        "controls-position": "compact",
        "exponential": true,
        "editable": false,
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
    tr.is_separator
      height: 0.75rem
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
