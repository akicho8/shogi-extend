<template lang="pug">
b-field.field_block.SwarsCustomSearchInputDate(custom-class="is-small")
  template(#label)
    | 日付
  b-datepicker(
    v-model="base.battled_at_range"
    placeholder=""
    icon="calendar-today"
    :icon-right="present_p(base.battled_at_range) ? 'close-circle' : ''"
    icon-right-clickable
    @icon-right-click.stop="clear_handle"
    @range-start="sound_play_click()"
    @range-end="sound_play_click()"
    range
    trap-focus
    :mobile-native="false"
    :size="base.input_element_size"
    position="is-top-right"
    )
</template>

<script>

import _ from "lodash"
import { support_child } from "./support_child.js"

export default {
  name: "SwarsCustomSearchInputVsUserKeys",
  mixins: [
    support_child,
  ],
  methods: {
    clear_handle() {
      this.sound_play_toggle(false)
      this.base.battled_at_range = []
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.SwarsCustomSearchInputDate
</style>
