<template lang="pug">
a.navbar_item.navbar_item_wide.SbThinkMarkToggleButton.think_mark_toggle_button_click_handle(
  @click="SB.think_mark_toggle_button_click_handle"
  v-if="SB.think_mark_button_show_p"
  )
  .mdi.mdi-pencil
  .mdi.mdi-circle-outline(v-if="SB.think_mark_mode_p")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbThinkMarkToggleButton",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support"
.SbThinkMarkToggleButton
  font-size: 1.75rem
  .mdi
    position: absolute
  .mdi-circle-outline
    font-size: 3.0rem
</style>
