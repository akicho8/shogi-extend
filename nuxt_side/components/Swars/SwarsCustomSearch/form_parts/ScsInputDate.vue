<template lang="pug">
b-field.field_block.ScsInputDate(custom-class="is-small")
  template(#label)
    | 日付
  b-datepicker(
    v-model="TheApp.battled_at_range"
    placeholder=""
    icon="calendar-today"
    :icon-right="$gs.present_p(TheApp.battled_at_range) ? 'close-circle' : ''"
    icon-right-clickable
    @icon-right-click.stop="clear_handle"
    @range-start="sfx_play_click()"
    @range-end="sfx_play_click()"
    range
    trap-focus
    :mobile-native="false"
    :size="TheApp.input_element_size"
    position="is-top-right"
    )
</template>

<script>

import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "ScsInputVsUserKeys",
  mixins: [
    support_child,
  ],
  methods: {
    clear_handle() {
      this.sfx_play_toggle(false)
      this.TheApp.battled_at_range = []
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ScsInputDate
  __css_keep__: 0
</style>
