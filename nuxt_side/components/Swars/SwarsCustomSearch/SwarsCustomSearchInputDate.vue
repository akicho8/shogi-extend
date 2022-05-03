<template lang="pug">
//- FIXME: @icon-right-click.prevent にする
b-field.field_block.SwarsCustomSearchInputDate(custom-class="is-small")
  template(#label)
    | 日付
  b-datepicker(
    v-model="base.battled_at_range"
    placeholder=""
    icon="calendar-today"
    :icon-right="present_p(base.battled_at_range) ? 'close-circle' : ''"
    icon-right-clickable
    @icon-right-click="clear_handle"
    range
    trap-focus
    :mobile-native="false"
    size="is-small"
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
      // if (this.present_p(this.base.battled_at_range)) {
      this.sound_play_click()
      this.base.battled_at_range = []
      // }
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.SwarsCustomSearchInputDate
</style>
